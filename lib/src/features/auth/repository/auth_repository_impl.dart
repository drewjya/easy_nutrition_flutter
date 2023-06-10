// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/features/recipe/model/recipe_model.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Ref ref;
  AuthRepositoryImpl({
    required this.ref,
  });
  @override
  Future<String> changePassword(
      {required String newPassword, required String oldPassword}) {
    throw UnimplementedError();
  }

  @override
  Future<String> login(
      {required String email, required String password}) async {
    try {
      final auth = await fb.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (auth.user == null) {
        throw "Gagal Login";
      }

      return "Success";
    } on fb.FirebaseAuthException catch (e) {
      throw "${e.message}";
    } catch (e) {
      throw "$e";
    }
  }

  @override
  Future<String> registerUser(
      {required String email,
      required String password,
      required String fullName}) async {
    try {
      final auth = await fb.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (auth.user == null) {
        throw "Gagal Membuat Akun";
      }
      ref.read(userProvider.notifier).createUser(
            userModel: User(
              id: auth.user!.uid,
              name: fullName,
              createdRecipe: [],
              favoriteRecipe: [],
              totalPoint: 0,
              tanggalJoin: DateTime.now(),
            ),
          );
      return "Success";
    } on fb.FirebaseAuthException catch (e) {
      throw "${e.message}";
    } catch (e) {
      throw "$e";
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref: ref);
});
