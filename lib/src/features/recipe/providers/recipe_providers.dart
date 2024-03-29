import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_nutrition/src/features/features.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class RecipeNotifier extends StreamNotifier<List<RecipeModel>> {
  final _uuid = const Uuid();
  @override
  Stream<List<RecipeModel>> build() {
    return FirebaseDatabase.instance
        .ref("recipe")
        .onValue
        .map((event) => event.snapshot.children.map((e) {
              log("${e.value}");
              return RecipeModel.fromMap(
                  jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>);
            }).toList());
  }

  Future createRecipe({
    required String name,
    required num calories,
    required List<String> categories,
    required List<Steps> steps,
    required Uint8List recipeFile,
    required List<IngredientRecipe> ingredientRecipe,
    required num timeNeeded,
    required String timeFormat,
    required String recipeId,
  }) async {
    final auth = this.ref.read(currUserProvider).asData?.value;
    if (auth == null) {
      throw "Not Authenticated";
    }
    final refStorage = FirebaseStorage.instance
        .ref()
        .child('recipe')
        .child('${_uuid.v4()}.jpg');
    await refStorage.putData(recipeFile);

    final recipeUrl = await refStorage.getDownloadURL();

    final oldSteps = steps;

    List<Steps> stepsData = [];

    for (var i = 0; i < oldSteps.length; i++) {
      final refStorage = FirebaseStorage.instance
          .ref()
          .child('Data')
          .child('${_uuid.v4()}.jpg');
      await refStorage.putData(oldSteps[i].file!);

      final stepsUrl = await refStorage.getDownloadURL();
      stepsData = [
        ...stepsData,
        Steps(desc: oldSteps[i].desc, fileUrl: stepsUrl, id: ""),
      ];
    }

    final recipeModel = RecipeModel(
        id: recipeId,
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

  Future updateRecipe(
      {required RecipeModel recipeModel, required Uint8List? file}) async {
    String recipeUrl = recipeModel.fileUrl;
    if (file != null) {
      final refStorage = FirebaseStorage.instance
          .ref()
          .child('recipe')
          .child('${_uuid.v4()}.jpg');
      await refStorage.putData(file);
      recipeUrl = await refStorage.getDownloadURL();
    }

    final oldSteps = recipeModel.steps;

    List<Steps> stepsData = [];

    for (var i = 0; i < oldSteps.length; i++) {
      if (oldSteps[i].file != null) {
        final refStorage = FirebaseStorage.instance
            .ref()
            .child('Data')
            .child('${_uuid.v4()}.jpg');
        await refStorage.putData(oldSteps[i].file!);
        final stepsUrl = await refStorage.getDownloadURL();
        stepsData = [
          ...stepsData,
          Steps(desc: oldSteps[i].desc, fileUrl: stepsUrl, id: ""),
        ];
      } else {
        stepsData = [
          ...stepsData,
          Steps(desc: oldSteps[i].desc, fileUrl: oldSteps[i].fileUrl, id: ""),
        ];
      }
    }

    final ref = FirebaseDatabase.instance.ref("recipe/${recipeModel.id}");
    await ref.update(recipeModel
        .copyWith(
          steps: stepsData,
          fileUrl: recipeUrl,
        )
        .toMap());
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
      required Uint8List? file}) {
    var data = <Steps>[];
    for (var item in state) {
      if (item.id == id) {
        data = [
          ...data,
          Steps(desc: content, fileUrl: picture, id: id, file: file)
        ];
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

  listSteps(List<Steps> steps) {
    state = steps.map((e) => e.copyWith(id: id.v4())).toList();
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
