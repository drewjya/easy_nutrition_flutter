import 'dart:convert';

import 'package:easy_nutrition/src/features/features.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class RecipeNotifier extends StreamNotifier<List<RecipeModel>> {
  final _uuid = const Uuid();
  @override
  Stream<List<RecipeModel>> build() {
    return FirebaseDatabase.instance.ref("recipe").onValue.map((event) => event
        .snapshot.children
        .map((e) => RecipeModel.fromMap(
            jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>))
        .toList());
  }

  Future createRecipe({required RecipeModel recipeModel}) async {
    final ref = FirebaseDatabase.instance.ref("recipe/${recipeModel.id}");
    await ref.set(recipeModel.toMap());
  }

  Future updateRecipe({required RecipeModel recipeModel}) async {
    final ref = FirebaseDatabase.instance.ref("recipe/${recipeModel.id}");
    await ref.update(recipeModel.toMap());
  }

  Future deleteRecipe({required RecipeModel recipeModel}) async {
    final ref = FirebaseDatabase.instance.ref("recipe/${recipeModel.id}");
    await ref.remove();
  }

  dummy() async {
    final userId = _uuid.v4();
    await createRecipe(
        recipeModel: RecipeModel(
            categoriesList: [],
            timeFormat: "seconds",
            timeNeeded: 12,
            fileUrl:
                "https://th.bing.com/th/id/OIP.BUKBU3OEkRGQRWJrUS4P3QHaHa?w=176&h=180&c=7&r=0&o=5&dpr=2&pid=1.7",
            id: _uuid.v4(),
            recipeName: "Ayam",
            authorId: userId,
            authorName: "Hauzan",
            rating: 4,
            reviews: [],
            steps: [],
            ingredientList: [
              IngredientRecipe(
                  ingredientId: _uuid.v4(), quantity: 5, unit: "gr"),
              IngredientRecipe(
                  ingredientId: _uuid.v4(), quantity: 10, unit: "cup"),
            ],
            totalLikes: 0));
    await createRecipe(
        recipeModel: RecipeModel(
            categoriesList: ["Hot Dishes"],
            timeFormat: "minutes",
            timeNeeded: 12,
            fileUrl:
                "https://posts-cdn.kueez.net/OAyTRw3lzuXbeail/image-PsVOkM5mC70yIrht.jpg",
            id: _uuid.v4(),
            recipeName: "Ayam 4",
            authorId: userId,
            authorName: "Hauzan",
            rating: 4,
            reviews: [],
            steps: [],
            ingredientList: [
              IngredientRecipe(
                  ingredientId: _uuid.v4(), quantity: 5, unit: "gr"),
              IngredientRecipe(
                  ingredientId: _uuid.v4(), quantity: 10, unit: "cup"),
            ],
            totalLikes: 0));
  }
}

final recipeProvider =
    StreamNotifierProvider<RecipeNotifier, List<RecipeModel>>(
        RecipeNotifier.new);
