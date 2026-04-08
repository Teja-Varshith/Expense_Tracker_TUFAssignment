import 'package:expense_tracker_tuf/features/auth/auth_repository.dart';
import 'package:expense_tracker_tuf/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (_) => const UserRepository(),
);

final userProvider = NotifierProvider<UserController, AppUser?>(
  UserController.new,
);

class UserController extends Notifier<AppUser?> {
  UserRepository get _repo => ref.read(userRepositoryProvider);

  @override
  AppUser? build() => _repo.fetchUser();

  Future<void> signUp({required String fullName, required String email}) async {
    state = await _repo.signUp(fullName: fullName, email: email);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = await _repo.signIn(email: email, password: password);
  }

  Future<void> updateUser({String? fullName, String? email}) async {
    if (state == null) return;
    state = await _repo.updateUser(state!, fullName: fullName, email: email);
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = null;
  }
}

final isLoggedInProvider = Provider<bool>(
  (ref) => ref.watch(userProvider) != null,
);
