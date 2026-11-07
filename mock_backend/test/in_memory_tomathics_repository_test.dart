import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tomathics_mock_backend/tomathics_mock_backend.dart';

void main() {
  late InMemoryTomathicsRepository repository;

  setUp(() {
    var clockTime = DateTime.utc(2026, 1, 1);
    repository = InMemoryTomathicsRepository(
      clock: () {
        final current = clockTime;
        clockTime = clockTime.add(const Duration(seconds: 1));
        return current;
      },
      executionTickInterval: const Duration(milliseconds: 5),
    );
  });

  tearDown(() {
    repository.dispose();
  });

  test(
    'seed recipes are generic, paginated, searchable, and resettable',
    () async {
      final firstPage = await repository.listRecipes(limit: 1);
      expect(firstPage.data, hasLength(1));
      expect(firstPage.total, 2);
      expect(firstPage.offset, 0);
      expect(firstPage.limit, 1);

      final secondPage = await repository.listRecipes(offset: 1, limit: 1);
      expect(secondPage.data, hasLength(1));
      expect(secondPage.data.single.id, isNot(firstPage.data.single.id));

      final search = await repository.listRecipes(
        filter: const RecipeFilter(search: 'demonstração'),
      );
      expect(search.data.single.name, 'Fluxo de demonstração');

      final created = await repository.createRecipe(_draft('Nova receita'));
      expect(created.id, 'recipe-0003');
      repository.reset();
      final reset = await repository.listRecipes();
      expect(reset.total, 2);
      expect(
        reset.data.map((recipe) => recipe.id),
        isNot(contains(created.id)),
      );
    },
  );

  test('create, update, duplicate, archive, and restore recipes', () async {
    final original = (await repository.listRecipes()).data.first;
    final updated = await repository.updateRecipe(
      original.id,
      _draft('Atualizada'),
    );
    expect(updated.name, 'Atualizada');
    expect(updated.createdAt, original.createdAt);
    expect(updated.updatedAt, isNot(original.updatedAt));

    final duplicate = await repository.duplicateRecipe(updated.id);
    expect(duplicate.name, 'Atualizada (cópia)');
    expect(duplicate.status, RecipeStatus.active);

    final archived = await repository.archiveRecipe(updated.id);
    expect(archived.status, RecipeStatus.archived);
    expect(archived.archivedAt, isNotNull);
    expect((await repository.listRecipes()).total, 2);
    expect(
      (await repository.listRecipes(
        filter: const RecipeFilter(includeArchived: true),
      )).total,
      3,
    );

    final restored = await repository.restoreRecipe(updated.id);
    expect(restored.status, RecipeStatus.active);
    expect(restored.archivedAt, isNull);
  });

  test('validates drafts and pagination using structured errors', () async {
    await expectLater(
      repository.createRecipe(_draft(' ')),
      throwsA(
        isA<MockApiException>()
            .having((error) => error.statusCode, 'statusCode', 400)
            .having((error) => error.code, 'code', 'VALIDATION_ERROR')
            .having(
              (error) => error.fieldErrors.keys,
              'field error keys',
              contains('name'),
            ),
      ),
    );

    await expectLater(
      repository.listRecipes(limit: 0),
      throwsA(
        isA<MockApiException>().having(
          (error) => error.fieldErrors.keys,
          'field error keys',
          contains('limit'),
        ),
      ),
    );
  });

  test('missing recipes return a structured not found error', () async {
    await expectLater(
      repository.getRecipe('missing'),
      throwsA(
        isA<MockApiException>()
            .having((error) => error.statusCode, 'statusCode', 404)
            .having((error) => error.code, 'code', 'NOT_FOUND'),
      ),
    );
  });

  test('typed graph configuration survives a JSON round trip', () {
    final graph = AutomationGraph(
      nodes: [
        AutomationNode(
          id: 'action-1',
          type: AutomationNodeType.action,
          title: 'Tap',
          position: const CanvasPosition(x: 12, y: 48),
          config: ActionConfiguration(const {'operation': 'tap'}),
        ),
      ],
      edges: const [],
      extensions: const {'vendorKey': 'value'},
    );
    final decoded = AutomationGraph.fromJson(
      jsonDecode(jsonEncode(graph.toJson())) as Map<String, Object?>,
    );

    expect(decoded.nodes.single.config, isA<ActionConfiguration>());
    expect(decoded.nodes.single.config.values['operation'], 'tap');
    expect(decoded.nodes.single.position.x, 12);
    expect(decoded.extensions['vendorKey'], 'value');
  });

  test(
    'invalid graph connections return field-level validation errors',
    () async {
      final invalid = RecipeDraft(
        name: 'Invalid graph',
        targetId: 'target-demo-01',
        graph: AutomationGraph(
          nodes: [
            AutomationNode(
              id: 'trigger',
              type: AutomationNodeType.trigger,
              title: 'Trigger',
              position: const CanvasPosition(x: 0, y: 0),
              config: TriggerConfiguration(),
            ),
          ],
          edges: const [
            AutomationEdge(id: 'edge', source: 'trigger', target: 'missing'),
          ],
        ),
      );

      await expectLater(
        repository.createRecipe(invalid),
        throwsA(
          isA<MockApiException>().having(
            (error) => error.fieldErrors.keys,
            'field error keys',
            contains('graph.edges[0].target'),
          ),
        ),
      );
    },
  );

  test(
    'success scenario progresses automatically and exposes paged events',
    () async {
      final recipe = (await repository.listRecipes()).data.first;
      final execution = await repository.startExecution(
        recipe.id,
        scenario: ExecutionScenario.success,
      );
      expect(execution.status, ExecutionStatus.queued);

      await _waitUntil(
        () async =>
            (await repository.getExecution(execution.id)).status ==
            ExecutionStatus.completed,
      );

      final completed = await repository.getExecution(execution.id);
      expect(completed.progress, 1);
      final firstEvents = await repository.listExecutionEvents(
        execution.id,
        limit: 2,
      );
      expect(firstEvents.total, 5);
      expect(firstEvents.data, hasLength(2));
      expect(firstEvents.data.first.status, ExecutionStatus.queued);
    },
  );

  test('waiting scenario progresses to completion', () async {
    final recipe = (await repository.listRecipes()).data.first;
    final execution = await repository.startExecution(
      recipe.id,
      scenario: ExecutionScenario.waiting,
    );

    await _waitUntil(
      () async =>
          (await repository.getExecution(execution.id)).status ==
          ExecutionStatus.completed,
    );

    final events = await repository.listExecutionEvents(execution.id);
    expect(events.data.map((event) => event.status), [
      ExecutionStatus.queued,
      ExecutionStatus.waiting,
      ExecutionStatus.running,
      ExecutionStatus.completed,
    ]);
  });

  test(
    'failure scenario ends as failed with a visible failure message',
    () async {
      final recipe = (await repository.listRecipes()).data.first;
      final execution = await repository.startExecution(
        recipe.id,
        scenario: ExecutionScenario.failure,
      );

      await _waitUntil(
        () async =>
            (await repository.getExecution(execution.id)).status ==
            ExecutionStatus.failed,
      );

      expect(
        (await repository.getExecution(execution.id)).failureMessage,
        contains('simulada'),
      );
    },
  );

  test(
    'running executions can be cancelled and terminal ones cannot',
    () async {
      final recipe = (await repository.listRecipes()).data.first;
      final execution = await repository.startExecution(recipe.id);
      await _waitUntil(
        () async =>
            (await repository.getExecution(execution.id)).status ==
            ExecutionStatus.running,
      );

      final cancelled = await repository.cancelExecution(execution.id);
      expect(cancelled.status, ExecutionStatus.cancelled);

      await expectLater(
        repository.cancelExecution(execution.id),
        throwsA(
          isA<MockApiException>().having(
            (error) => error.statusCode,
            'statusCode',
            409,
          ),
        ),
      );
    },
  );

  test('demo session is fixed and does not validate credentials', () async {
    expect(await repository.currentDemoSession(), isNull);
    final first = await repository.signInDemo();
    final second = await repository.signInDemo();
    expect(first.id, 'demo-session');
    expect(first, same(second));
    await repository.signOutDemo();
    expect(await repository.currentDemoSession(), isNull);
  });
}

RecipeDraft _draft(String name) => RecipeDraft(
  name: name,
  targetId: 'target-demo-01',
  graph: AutomationGraph(
    nodes: [
      AutomationNode(
        id: 'trigger',
        type: AutomationNodeType.trigger,
        title: 'Trigger',
        position: const CanvasPosition(x: 0, y: 0),
        config: TriggerConfiguration(),
      ),
    ],
    edges: const [],
  ),
);

Future<void> _waitUntil(Future<bool> Function() condition) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (await condition()) return;
    await Future<void>.delayed(const Duration(milliseconds: 2));
  }
  fail('Condition was not reached before timeout.');
}
