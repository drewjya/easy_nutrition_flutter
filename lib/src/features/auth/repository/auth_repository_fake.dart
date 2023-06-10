import 'auth_repository.dart';

class AuthRepositoryFake extends AuthRepository {
  @override
  Future<String> changePassword(
      {required String newPassword, required String oldPassword}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<String> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<String> registerUser(
      {required String email,
      required String password,
      required String fullName}) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
