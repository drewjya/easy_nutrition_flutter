import 'package:easy_nutrition/src/features/features.dart';

abstract class AuthRepository {
  Future<String> registerUser(
      {required String email,
      required String password,
      
      required String fullName});
  Future<String> login({required String email, required String password});
  Future<String> changePassword(
      {required String newPassword, required String oldPassword});
}
