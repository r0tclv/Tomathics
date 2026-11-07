import '../models/execution.dart';
import '../models/recipe.dart';

/// Application-facing contract. A future HTTP repository can implement the
/// same methods without coupling screens to this in-memory implementation.
abstract interface class TomathicsRepository {
  Future<RecipePage> listRecipes({
    RecipeFilter filter = const RecipeFilter(),
    int offset = 0,
    int limit = 20,
  });

  Future<Recipe> getRecipe(String id);

  Future<Recipe> createRecipe(RecipeDraft draft);

  /// Replaces editable recipe fields while preserving identity and history.
  Future<Recipe> updateRecipe(String id, RecipeDraft draft);

  Future<Recipe> duplicateRecipe(String id);

  Future<Recipe> archiveRecipe(String id);

  Future<Recipe> restoreRecipe(String id);

  Future<Execution> startExecution(
    String recipeId, {
    ExecutionScenario scenario = ExecutionScenario.success,
  });

  Future<Execution> getExecution(String id);

  Future<Execution> cancelExecution(String id);

  Future<ExecutionEventPage> listExecutionEvents(
    String executionId, {
    int offset = 0,
    int limit = 20,
  });

  Future<DemoSession> signInDemo();

  Future<DemoSession?> currentDemoSession();

  Future<void> signOutDemo();
}
