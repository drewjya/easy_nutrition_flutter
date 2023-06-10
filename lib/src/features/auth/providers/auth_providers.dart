// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/features/auth/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthNotifier extends StateNotifier<AsyncValue<String?>> {
  AuthNotifier({required this.ref}) : super(const AsyncData(null));
  final Ref ref;

  createAccount(
      {required String email,
      required String password,
      required String fullName}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref
        .read(authRepositoryProvider)
        .registerUser(email: email, password: password, fullName: fullName));
  }

  login(
    {required String email,
      required String password,}
  )async{
     state = const AsyncLoading();
     state = await AsyncValue.guard(() => ref
        .read(authRepositoryProvider)
        .login(email: email, password: password));
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<String?>>(
  (ref) => AuthNotifier(ref: ref),
);
