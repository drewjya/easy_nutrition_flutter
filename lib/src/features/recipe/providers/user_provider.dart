import 'dart:convert';

import 'package:easy_nutrition/src/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

class UserNotifier extends StreamNotifier<List<User>> {
  @override
  Stream<List<User>> build() {
    return FirebaseDatabase.instance.ref("users").onValue.map((event) {
      return event.snapshot.children.map((e) {
        return User.fromMap(
            jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>);
      }).toList();
    });
  }

  Future createUser({required User userModel}) async {
    final ref = FirebaseDatabase.instance.ref("users/${userModel.id}");
    await ref.set(userModel.toMap());
  }

  Future updateUser({required String id, required User user}) async {
    final ref = FirebaseDatabase.instance.ref("users/$id");
    await ref.update(user.toMap());
  }
}

final userProvider =
    StreamNotifierProvider<UserNotifier, List<User>>(UserNotifier.new);

class CurrentUser extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    final currUser = ref.watch(authStateChangesProvider).asData?.value?.uid;
    if (currUser == null) {
      return null;
    }
    final value = ref.watch(userProvider);
    final data = value.asData?.value;
    if (data == null || data.isEmpty) {
      return null;
    }
    User? user;
    for (var i = 0; i < data.length; i++) {
      if (data[i].id == currUser) {
        user = data[i];
        break;
      }
    }

    return user;
  }

  likeDislike({required String recipeId, required bool favorite}) {
    final user = state.asData?.value;
    if (user == null) {
      return;
    }
    var favoritedRecipe = user.favoriteRecipe;
    if (favorite) {
      favoritedRecipe = [...favoritedRecipe, recipeId];
    } else {
      favoritedRecipe.remove(recipeId);
    }
    ref.read(userProvider.notifier).updateUser(
        id: user.id, user: user.copyWith(favoriteRecipe: favoritedRecipe));
  }

  Future createRecipe({required String recipeId}) async {
    final user = state.asData?.value;
    if (user == null) {
      return;
    }
    var createdRecipe = user.createdRecipe;

    createdRecipe = [...createdRecipe, recipeId];

    ref.read(userProvider.notifier).updateUser(
        id: user.id,
        user: user.copyWith(
          createdRecipe: createdRecipe,
        ));
  }

  uploadPicture(Uint8List file) async {
    final user = state.asData?.value;

    if (user == null) {
      return;
    }
    final oldUrl = user.profileUrl;
    const uuid = Uuid();
    final refStorage = FirebaseStorage.instance
        .ref()
        .child('profile')
        .child('${uuid.v4()}.jpg');
    await refStorage.putData(file);
    final getUrl = await refStorage.getDownloadURL();
    if (oldUrl != null) {
      final removeRef = FirebaseStorage.instance.refFromURL(oldUrl);
      await removeRef.delete();
    }
    ref.read(userProvider.notifier).updateUser(
        id: user.id,
        user: user.copyWith(
          profileUrl: getUrl,
        ));
  }

  changeDescription({String? description, String? profileName}) async {
    if (description == null && profileName == null) {
      return;
    }
    final user = state.asData?.value;

    if (user == null) {
      return;
    }

    ref.read(userProvider.notifier).updateUser(
        id: user.id,
        user: user.copyWith(
          desc: description,
          name: profileName,
        ));
  }
}

final currUserProvider =
    AsyncNotifierProvider<CurrentUser, User?>(CurrentUser.new);

final authStateChangesProvider = StreamProvider<fb.User?>(
    (ref) => fb.FirebaseAuth.instance.authStateChanges());
