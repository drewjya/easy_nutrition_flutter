import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_nutrition/src/features/features.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future createRecipe({
    required String name,
    required num calories,
    required List<String> categories,
    required List<Steps> steps,
    required File recipeFile,
    required List<IngredientRecipe> ingredientRecipe,
    required num timeNeeded,
    required String timeFormat,
  }) async {
    final auth = this.ref.read(currUserProvider).asData?.value;
    if (auth == null) {
      throw "Not Authenticated";
    }
    final refStorage = FirebaseStorage.instance
        .ref()
        .child('recipe')
        .child('${_uuid.v4()}.jpg');
    await refStorage.putFile(recipeFile);

    final recipeUrl = await refStorage.getDownloadURL();

    final oldSteps = steps;

    List<Steps> stepsData = [];

    for (var i = 0; i < oldSteps.length; i++) {
      final refStorage = FirebaseStorage.instance
          .ref()
          .child('Data')
          .child('${_uuid.v4()}.jpg');
      await refStorage.putFile(oldSteps[i].file!);

      final stepsUrl = await refStorage.getDownloadURL();
      stepsData = [
        ...stepsData,
        Steps(desc: oldSteps[i].desc, fileUrl: stepsUrl, id: ""),
      ];
    }
    log("${stepsData.map((e) => e.toMap()).toList()}");

    final recipeModel = RecipeModel(
        id: _uuid.v4(),
        recipeName: name,
        authorId: auth.id,
        authorName: auth.name,
        rating: 0,
        reviews: [],
        calories: calories,
        steps: stepsData,
        ingredientList: ingredientRecipe,
        totalLikes: 0,
        categoriesList: categories,
        timeNeeded: timeNeeded,
        timeFormat: timeFormat,
        fileUrl: recipeUrl);

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

class StepsNotifier extends AutoDisposeNotifier<List<Steps>> {
  final id = const Uuid();
  @override
  build() {
    return [
      Steps(desc: "", fileUrl: "", id: id.v4()),
    ];
  }

  addStepPlaceHolder() {
    state = [
      ...state,
      Steps(desc: "", fileUrl: "", id: id.v4()),
    ];
  }

  updateStep(
      {required String content,
      required String picture,
      required String id,
      required File? file}) {
    var data = <Steps>[];
    for (var item in state) {
      if (item.id == id) {
        data = [...data, Steps(desc: content, fileUrl: "", id: id, file: file)];
      } else {
        data = [...data, item];
      }
    }
    state = data;
  }

  removeStep({required String id}) {
    var newState = state;
    newState.removeWhere((element) => element.id == id);
    state = [];
    state = newState;
  }
}

final currentStepProvider =
    NotifierProvider.autoDispose<StepsNotifier, List<Steps>>(StepsNotifier.new);

extension Iterablex<T> on Iterable<T> {
  List<R> mapIndexed<R>(R Function(T item, int index) toElement) {
    List<R> result = [];
    for (var i = 0; i < length; i++) {
      result = [...result, toElement(elementAt(i), i)];
    }
    return result;
  }
}
