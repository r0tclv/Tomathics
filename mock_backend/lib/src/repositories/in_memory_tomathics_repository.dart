import 'dart:async';

import '../errors/mock_api_exception.dart';
import '../models/automation_graph.dart';
import '../models/execution.dart';
import '../models/recipe.dart';
import 'tomathics_repository.dart';

typedef Clock = DateTime Function();

/// In-memory development backend. It performs no network or automation work.
class InMemoryTomathicsRepository implements TomathicsRepository {
  InMemoryTomathicsRepository({
    Clock? clock,
    this.executionTickInterval = const Duration(milliseconds: 900),
  }) : _clock = clock ?? DateTime.now {
    if (executionTickInterval <= Duration.zero) {
      throw ArgumentError.value(
        executionTickInterval,
        'executionTickInterval',
        'Must be greater than zero.',
      );
    }
    reset();
  }

  final Clock _clock;
  final Duration executionTickInterval;
  final Map<String, Recipe> _recipes = {};
  final Map<String, Execution> _executions = {};
  final Map<String, List<ExecutionEvent>> _events = {};
  final Map<String, List<_ExecutionStep>> _remainingSteps = {};
  final Map<String, Timer> _executionTimers = {};
  int _recipeSequence = 0;
  int _executionSequence = 0;
  int _eventSequence = 0;
  DemoSession? _session;
  bool _disposed = false;

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  @override
  Future<RecipePage> listRecipes({
    RecipeFilter filter = const RecipeFilter(),
    int offset = 0,
    int limit = defaultPageSize,
  }) async {
    _ensureNotDisposed();
    _validatePage(offset, limit);
    final search = filter.search?.trim().toLowerCase();
    final recipes = _recipes.values.where((recipe) {
      if (!filter.includeArchived && recipe.status == RecipeStatus.archived) {
        return false;
      }
      if (filter.targetId != null && recipe.targetId != filter.targetId) {
        return false;
      }
      if (search != null &&
          search.isNotEmpty &&
          !recipe.name.toLowerCase().contains(search) &&
          !recipe.description.toLowerCase().contains(search)) {
        return false;
      }
      return true;
    }).toList()..sort((a, b) => a.name.compareTo(b.name));
    final start = offset.clamp(0, recipes.length);
    final end = (start + limit).clamp(0, recipes.length);
    return RecipePage(
      data: recipes.sublist(start, end),
      offset: offset,
      limit: limit,
      total: recipes.length,
    );
  }

  @override
  Future<Recipe> getRecipe(String id) async {
    _ensureNotDisposed();
    return _recipes[id] ?? _notFound('recipe', id);
  }

  @override
  Future<Recipe> createRecipe(RecipeDraft draft) async {
    _ensureNotDisposed();
    _validateDraft(draft);
    final now = _now();
    final id = _nextRecipeId();
    final recipe = Recipe(
      id: id,
      name: draft.name.trim(),
      description: draft.description.trim(),
      status: RecipeStatus.active,
      targetId: draft.targetId.trim(),
      graph: draft.graph,
      createdAt: now,
      updatedAt: now,
    );
    _recipes[id] = recipe;
    return recipe;
  }

  @override
  Future<Recipe> updateRecipe(String id, RecipeDraft draft) async {
    _ensureNotDisposed();
    final current = await getRecipe(id);
    if (current.status == RecipeStatus.archived) {
      throw _conflict('Archived recipes cannot be edited.');
    }
    _validateDraft(draft);
    final updated = current.copyWith(
      name: draft.name.trim(),
      description: draft.description.trim(),
      targetId: draft.targetId.trim(),
      graph: draft.graph,
      updatedAt: _now(),
    );
    _recipes[id] = updated;
    return updated;
  }

  @override
  Future<Recipe> duplicateRecipe(String id) async {
    _ensureNotDisposed();
    final source = await getRecipe(id);
    final now = _now();
    final newId = _nextRecipeId();
    final duplicate = Recipe(
      id: newId,
      name: '${source.name} (cópia)',
      description: source.description,
      status: RecipeStatus.active,
      targetId: source.targetId,
      graph: source.graph,
      createdAt: now,
      updatedAt: now,
    );
    _recipes[newId] = duplicate;
    return duplicate;
  }

  @override
  Future<Recipe> archiveRecipe(String id) async {
    _ensureNotDisposed();
    final recipe = await getRecipe(id);
    if (recipe.status == RecipeStatus.archived) {
      throw _conflict('Recipe is already archived.');
    }
    final now = _now();
    final archived = recipe.copyWith(
      status: RecipeStatus.archived,
      archivedAt: now,
      updatedAt: now,
    );
    _recipes[id] = archived;
    return archived;
  }

  @override
  Future<Recipe> restoreRecipe(String id) async {
    _ensureNotDisposed();
    final recipe = await getRecipe(id);
    if (recipe.status != RecipeStatus.archived) {
      throw _conflict('Only archived recipes can be restored.');
    }
    final restored = recipe.copyWith(
      status: RecipeStatus.active,
      clearArchivedAt: true,
      updatedAt: _now(),
    );
    _recipes[id] = restored;
    return restored;
  }

  @override
  Future<Execution> startExecution(
    String recipeId, {
    ExecutionScenario scenario = ExecutionScenario.success,
  }) async {
    _ensureNotDisposed();
    final recipe = await getRecipe(recipeId);
    if (recipe.status == RecipeStatus.archived) {
      throw _conflict('Archived recipes cannot be executed.');
    }

    final now = _now();
    final id = _nextExecutionId();
    final execution = Execution(
      id: id,
      recipeId: recipeId,
      status: ExecutionStatus.queued,
      progress: 0,
      createdAt: now,
      updatedAt: now,
    );
    _executions[id] = execution;
    _events[id] = [];
    _remainingSteps[id] = _scenarioSteps(scenario);
    _appendEvent(
      execution,
      type: 'execution.queued',
      message: 'Execução adicionada à fila.',
    );
    _scheduleExecution(id);
    return execution;
  }

  @override
  Future<Execution> getExecution(String id) async {
    _ensureNotDisposed();
    return _executions[id] ?? _notFound('execution', id);
  }

  @override
  Future<Execution> cancelExecution(String id) async {
    _ensureNotDisposed();
    final execution = await getExecution(id);
    if (_isTerminal(execution.status)) {
      throw _conflict('A terminal execution cannot be cancelled.');
    }
    _executionTimers.remove(id)?.cancel();
    _remainingSteps.remove(id);
    final cancelled = _updateExecution(
      execution,
      status: ExecutionStatus.cancelled,
    );
    _appendEvent(
      cancelled,
      type: 'execution.cancelled',
      message: 'Execução cancelada.',
    );
    return cancelled;
  }

  @override
  Future<ExecutionEventPage> listExecutionEvents(
    String executionId, {
    int offset = 0,
    int limit = defaultPageSize,
  }) async {
    _ensureNotDisposed();
    _validatePage(offset, limit);
    if (!_executions.containsKey(executionId)) {
      throw _notFound('execution', executionId);
    }
    final events = _events[executionId]!;
    final start = offset.clamp(0, events.length);
    final end = (start + limit).clamp(0, events.length);
    return ExecutionEventPage(
      data: events.sublist(start, end),
      offset: offset,
      limit: limit,
      total: events.length,
    );
  }

  @override
  Future<DemoSession> signInDemo() async {
    _ensureNotDisposed();
    return _session = const DemoSession(
      id: 'demo-session',
      displayName: 'Operador de demonstração',
      email: 'demo@tomathics.local',
    );
  }

  @override
  Future<DemoSession?> currentDemoSession() async {
    _ensureNotDisposed();
    return _session;
  }

  @override
  Future<void> signOutDemo() async {
    _ensureNotDisposed();
    _session = null;
  }

  /// Restores seed recipes and clears executions and the demo session.
  void reset() {
    _ensureNotDisposed();
    for (final timer in _executionTimers.values) {
      timer.cancel();
    }
    _executionTimers.clear();
    _executions.clear();
    _events.clear();
    _remainingSteps.clear();
    _recipes.clear();
    _recipeSequence = 0;
    _executionSequence = 0;
    _eventSequence = 0;
    _session = null;

    final now = _now();
    for (final seed in _seedRecipes) {
      final id = _nextRecipeId();
      _recipes[id] = Recipe(
        id: id,
        name: seed.name,
        description: seed.description,
        status: RecipeStatus.active,
        targetId: seed.targetId,
        graph: seed.graph,
        createdAt: now,
        updatedAt: now,
      );
    }
  }

  /// Stops scheduled simulation work. Call when the owning app is disposed.
  void dispose() {
    if (_disposed) return;
    for (final timer in _executionTimers.values) {
      timer.cancel();
    }
    _executionTimers.clear();
    _disposed = true;
  }

  void _scheduleExecution(String id) {
    _executionTimers[id] = Timer.periodic(executionTickInterval, (_) {
      _advanceExecution(id);
    });
  }

  void _advanceExecution(String id) {
    final current = _executions[id];
    final steps = _remainingSteps[id];
    if (current == null || steps == null || steps.isEmpty) {
      _executionTimers.remove(id)?.cancel();
      _remainingSteps.remove(id);
      return;
    }

    final step = steps.removeAt(0);
    final updated = _updateExecution(
      current,
      status: step.status,
      progress: step.progress,
      failureMessage: step.failureMessage,
    );
    _appendEvent(
      updated,
      type: 'execution.${updated.status.name}',
      message: step.message,
    );
    if (steps.isEmpty) {
      _executionTimers.remove(id)?.cancel();
      _remainingSteps.remove(id);
    }
  }

  Execution _updateExecution(
    Execution current, {
    required ExecutionStatus status,
    double? progress,
    String? failureMessage,
  }) {
    final updated = Execution(
      id: current.id,
      recipeId: current.recipeId,
      status: status,
      progress: progress ?? current.progress,
      createdAt: current.createdAt,
      updatedAt: _now(),
      failureMessage: failureMessage,
    );
    _executions[current.id] = updated;
    return updated;
  }

  void _appendEvent(
    Execution execution, {
    required String type,
    required String message,
  }) {
    final events = _events[execution.id]!;
    events.add(
      ExecutionEvent(
        id: 'event-${(++_eventSequence).toString().padLeft(4, '0')}',
        executionId: execution.id,
        type: type,
        message: message,
        createdAt: _now(),
        status: execution.status,
      ),
    );
  }

  List<_ExecutionStep> _scenarioSteps(ExecutionScenario scenario) =>
      List<_ExecutionStep>.of(switch (scenario) {
        ExecutionScenario.success => const [
          _ExecutionStep(ExecutionStatus.running, 0.2, 'Execução iniciada.'),
          _ExecutionStep(
            ExecutionStatus.waiting,
            0.5,
            'Aguardando a próxima etapa.',
          ),
          _ExecutionStep(ExecutionStatus.running, 0.8, 'Execução retomada.'),
          _ExecutionStep(ExecutionStatus.completed, 1, 'Execução concluída.'),
        ],
        ExecutionScenario.failure => const [
          _ExecutionStep(ExecutionStatus.running, 0.35, 'Execução iniciada.'),
          _ExecutionStep(
            ExecutionStatus.failed,
            0.35,
            'A simulação encontrou uma falha.',
            failureMessage: 'Falha simulada pelo cenário selecionado.',
          ),
        ],
        ExecutionScenario.waiting => const [
          _ExecutionStep(
            ExecutionStatus.waiting,
            0.2,
            'Aguardando uma condição simulada.',
          ),
          _ExecutionStep(
            ExecutionStatus.running,
            0.65,
            'Condição atendida; execução retomada.',
          ),
          _ExecutionStep(ExecutionStatus.completed, 1, 'Execução concluída.'),
        ],
      });

  static bool _isTerminal(ExecutionStatus status) => switch (status) {
    ExecutionStatus.completed ||
    ExecutionStatus.failed ||
    ExecutionStatus.cancelled => true,
    _ => false,
  };

  void _validateDraft(RecipeDraft draft) {
    final errors = <String, List<String>>{};
    if (draft.name.trim().isEmpty) {
      errors['name'] = ['Recipe name is required.'];
    }
    if (draft.targetId.trim().isEmpty) {
      errors['targetId'] = ['Target ID is required.'];
    }
    errors.addAll(draft.graph.validate());
    if (errors.isNotEmpty) {
      throw MockApiException(
        statusCode: 400,
        code: 'VALIDATION_ERROR',
        message: 'The recipe is invalid.',
        fieldErrors: errors,
      );
    }
  }

  void _validatePage(int offset, int limit) {
    final errors = <String, List<String>>{};
    if (offset < 0) {
      errors['offset'] = ['Offset must be zero or greater.'];
    }
    if (limit < 1 || limit > maxPageSize) {
      errors['limit'] = ['Limit must be between 1 and $maxPageSize.'];
    }
    if (errors.isNotEmpty) {
      throw MockApiException(
        statusCode: 400,
        code: 'VALIDATION_ERROR',
        message: 'Pagination parameters are invalid.',
        fieldErrors: errors,
      );
    }
  }

  String _nextRecipeId() =>
      'recipe-${(++_recipeSequence).toString().padLeft(4, '0')}';

  String _nextExecutionId() =>
      'execution-${(++_executionSequence).toString().padLeft(4, '0')}';

  DateTime _now() => _clock().toUtc();

  void _ensureNotDisposed() {
    if (_disposed) {
      throw StateError('InMemoryTomathicsRepository has been disposed.');
    }
  }

  static Never _notFound(String resource, String id) => throw MockApiException(
    statusCode: 404,
    code: 'NOT_FOUND',
    message: '${_capitalize(resource)} "$id" was not found.',
  );

  static MockApiException _conflict(String message) =>
      MockApiException(statusCode: 409, code: 'CONFLICT', message: message);

  static String _capitalize(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';

  static final _seedRecipes = <RecipeDraft>[
    RecipeDraft(
      name: 'Fluxo de demonstração',
      description: 'Receita fictícia para exercitar o editor e o monitor.',
      targetId: 'target-demo-01',
      graph: _seedGraph('seed-01'),
    ),
    RecipeDraft(
      name: 'Rotina de exemplo',
      description: 'Outro fluxo inicial sem integração com plataformas.',
      targetId: 'target-demo-01',
      graph: _seedGraph('seed-02'),
    ),
  ];

  static AutomationGraph _seedGraph(String prefix) => AutomationGraph(
    nodes: [
      AutomationNode(
        id: '$prefix-trigger',
        type: AutomationNodeType.trigger,
        title: 'Iniciar fluxo',
        position: const CanvasPosition(x: 80, y: 120),
        config: TriggerConfiguration(),
      ),
      AutomationNode(
        id: '$prefix-action',
        type: AutomationNodeType.action,
        title: 'Ação demonstrativa',
        position: const CanvasPosition(x: 340, y: 120),
        config: ActionConfiguration(),
      ),
    ],
    edges: [
      AutomationEdge(
        id: '$prefix-edge-01',
        source: '$prefix-trigger',
        target: '$prefix-action',
      ),
    ],
  );
}

class _ExecutionStep {
  const _ExecutionStep(
    this.status,
    this.progress,
    this.message, {
    this.failureMessage,
  });

  final ExecutionStatus status;
  final double progress;
  final String message;
  final String? failureMessage;
}
