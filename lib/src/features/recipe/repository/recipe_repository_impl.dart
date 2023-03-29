import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'recipe_repository.dart';

class RecipeRepositoryImpl extends RecipeRepository {
  // TODO add your methods here
}

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepositoryImpl();
});
