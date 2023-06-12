import 'dart:convert';
import 'dart:developer';

import 'package:easy_nutrition/src/features/features.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IngredientsNotifier extends StreamNotifier<List<Ingredients>> {
  @override
  Stream<List<Ingredients>> build() {
    return FirebaseDatabase.instance.ref("ingredients").onValue.map((event) =>
        event
            .snapshot.children
            .map((e) => Ingredients.fromMap(
                jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>))
            .toList());
  }

  Future createIngredients({required Ingredients ingredientModel}) async {
    final user = ref.read(currUserProvider).asData?.value;
    if (user == null) {
      throw "User Logged Out";
    }
    final ingredientRef =
        FirebaseDatabase.instance.ref("ingredients/${ingredientModel.id}");
    await ingredientRef.set(ingredientModel.toMap());
  }

  Future updateIngredients(
      {required String id, required Ingredients ingredientModel}) async {
    final ref = FirebaseDatabase.instance.ref("Ingredients/$id");
    await ref.update(ingredientModel.toMap());
  }
}

final ingredientsProvider =
    StreamNotifierProvider<IngredientsNotifier, List<Ingredients>>(
        IngredientsNotifier.new);

class IngredientCreatedNotifier extends Notifier<Ingredients?> {
  @override
  build() {
    return null;
  }

  addIngredients({required Ingredients ingredients}) {
    state = ingredients;
  }
}

class CurrRecipeIngredient extends AutoDisposeNotifier<List<IngredientRecipe>> {
  @override
  build() {
    return [];
  }

  addIngredients({required IngredientRecipe ingredients}) {
    var recipeIngredients = state.map((e) => e.ingredientId).toList();
    var newState = state;
    bool isContained = false;
    for (var i = 0; i < recipeIngredients.length; i++) {
      if (recipeIngredients[i] == ingredients.ingredientId) {
        isContained = true;
        log("$ingredients");
        log("${newState[i]}");
        newState[i] = ingredients;
        log("${newState[i]}");

        break;
      }
    }
    if (isContained) {
      state = [];
      state = newState;
      return;
    }
    state = [...newState, ingredients];
  }

  removeIngredients({required String ingredientId}) {
    var newState = state;
    state = [];
    newState.removeWhere((element) => element.ingredientId == ingredientId);
    state = newState;
  }
}

final currRecipeIngredientProvider =
    NotifierProvider.autoDispose<CurrRecipeIngredient, List<IngredientRecipe>>(
        CurrRecipeIngredient.new);
