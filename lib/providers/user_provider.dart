import 'package:expense_tracker_tuf/models/user_model.dart';
import 'package:expense_tracker_tuf/services/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final userProvider = NotifierProvider<UserNotifier, AppUser?>(() {
  return UserNotifier();
});

class UserNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() {
    return HiveService.getUser();
  }

  Future<void> signUp({
    required String fullName,
    required String email,
  }) async {
    final user = AppUser(
      id: const Uuid().v4(),
      fullName: fullName,
      email: email,
    );
    await HiveService.saveUser(user);
    state = user;
  }

  Future<void> signIn({
    required String email,
  }) async {
    final existing = HiveService.getUser();
    if (existing != null && existing.email == email) {
      state = existing;
    } else {
      final user = AppUser(
        id: const Uuid().v4(),
        fullName: email.split('@').first,
        email: email,
      );
      await HiveService.saveUser(user);
      state = user;
    }
  }

  Future<void> updateUser({String? fullName, String? email}) async {
    if (state == null) return;
    final updated = state!.copyWith(
      fullName: fullName,
      email: email,
    );
    await HiveService.saveUser(updated);
    state = updated;
  }

  Future<void> signOut() async {
    await HiveService.deleteUser();
    state = null;
  }
}

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(userProvider) != null;
});
