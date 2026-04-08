import 'package:expense_tracker_tuf/models/user_model.dart';
import 'package:expense_tracker_tuf/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  const UserRepository();

  AppUser? fetchUser() => HiveService.getUser();

  Future<AppUser> signUp({
    required String fullName,
    required String email,
  }) async {
    final existing = HiveService.getUser();
    if (existing != null && existing.email == email) {
      throw Exception(
        'An account with this email already exists. Please sign in.',
      );
    }
    final user = AppUser(
      id: const Uuid().v4(),
      fullName: fullName,
      email: email,
    );
    await HiveService.saveUser(user);
    return user;
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final existing = HiveService.getUser();
    if (existing == null) {
      throw Exception('No account found. Please sign up first.');
    }
    if (existing.email != email) {
      throw Exception('No account found with this email.');
    }
    return existing;
  }

  Future<AppUser> updateUser(
    AppUser current, {
    String? fullName,
    String? email,
  }) async {
    final updated = current.copyWith(fullName: fullName, email: email);
    await HiveService.saveUser(updated);
    return updated;
  }

  Future<void> signOut() => HiveService.deleteUser();
}
