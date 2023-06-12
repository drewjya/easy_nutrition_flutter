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
}

final recipeProvider =
    StreamNotifierProvider<RecipeNotifier, List<RecipeModel>>(
        RecipeNotifier.new);

class StepsNotifier extends Notifier<List<Steps>> {
  @override
  build() {
    return [];
  }

  addStep({required String content, required String picture}) {
    final id = Uuid().v4();
    state = [
      ...state,
      Steps(
        desc: content,
        id: id,
        fileUrl: picture,
      ),
    ];
  }

  removeStep({required String id}) {
    var newState = state;
    newState.removeWhere((element) => element.id == id);
    state = [];
    state = newState;
  }
}
