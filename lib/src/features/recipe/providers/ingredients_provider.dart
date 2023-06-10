import 'dart:convert';

import 'package:easy_nutrition/src/features/features.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IngredientsNotifier extends StreamNotifier<List<Ingredients>> {
  @override
  Stream<List<Ingredients>> build() {
    return FirebaseDatabase.instance.ref("ingredientss").onValue.map((event) =>
        event.snapshot.children
            .map((e) => Ingredients.fromMap(
                jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>))
            .toList());
  }

  Future createRecipe({required Ingredients ingredientModel}) async {
    final ref = FirebaseDatabase.instance.ref("Ingredientss");
    await ref.set(ingredientModel.toMap());
  }

  Future updateRecipe(
      {required String id, required Ingredients ingredientModel}) async {
    final ref = FirebaseDatabase.instance.ref("Ingredientss/$id");
    await ref.update(ingredientModel.toMap());
  }
}

final recipeProvider =
    StreamNotifierProvider<IngredientsNotifier, List<Ingredients>>(
        IngredientsNotifier.new);
