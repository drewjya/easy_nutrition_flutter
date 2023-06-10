import 'dart:convert';
import 'dart:developer';

import 'package:easy_nutrition/src/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class UserNotifier extends StreamNotifier<List<User>> {
  @override
  Stream<List<User>> build() {
    return FirebaseDatabase.instance.ref("users").onValue.map((event) {
      return event.snapshot.children.map((e) {
        log("${e.value}");
        return User.fromMap(
            jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>);
      }).toList();
    });
  }

  Future createUser({required User userModel}) async {
    final ref = FirebaseDatabase.instance.ref("users/${userModel.id}");
    await ref.set(userModel.toMap());
  }

  Future updateUser({required String id, required User recipeModel}) async {
    final ref = FirebaseDatabase.instance.ref("users/$id");
    await ref.update(recipeModel.toMap());
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
    return ref.watch(userProvider.select((value) {
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
    }));
  }
}

final currUserProvider =
    AsyncNotifierProvider<CurrentUser, User?>(CurrentUser.new);

final authStateChangesProvider = StreamProvider<fb.User?>(
    (ref) => fb.FirebaseAuth.instance.authStateChanges());
