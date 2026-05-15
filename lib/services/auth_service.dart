import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../models/user_model.dart';
import 'storage_service.dart';

class AuthResult {
  const AuthResult({
    required this.success,
    this.message,
    this.user,
  });

  final bool success;
  final String? message;
  final UserModel? user;
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();
  final StorageService _storageService = StorageService();

  static const String _adminEmail = 'admin@physicar.com';
  static const String _adminPassword = 'admin123';

  Future<void> initialize() async {
    final users = await getUsers();
    final hasAdmin = users.any(
      (user) => user.email.toLowerCase() == _adminEmail,
    );

    if (!hasAdmin) {
      final updatedUsers = List<UserModel>.from(users)
        ..add(
          UserModel(
            name: 'Admin',
            email: _adminEmail,
            password: _hashPassword(_adminPassword),
            role: 'admin',
          ),
        );
      await _saveUsers(updatedUsers);
    }
  }

  Future<List<UserModel>> getUsers() async {
    final jsonUsers = await _storageService.readUsers();
    return jsonUsers.map(UserModel.fromJson).toList();
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    await initialize();

    final normalizedEmail = email.trim().toLowerCase();
    final users = await getUsers();

    final alreadyExists = users.any(
      (user) => user.email.toLowerCase() == normalizedEmail,
    );

    if (alreadyExists) {
      return const AuthResult(
        success: false,
        message: 'Email sudah terdaftar. Gunakan email lain.',
      );
    }

    final newUser = UserModel(
      name: name.trim(),
      email: normalizedEmail,
      password: _hashPassword(password.trim()),
      role: role,
    );

    final updatedUsers = List<UserModel>.from(users)..add(newUser);
    await _saveUsers(updatedUsers);

    return AuthResult(
      success: true,
      message: 'Registrasi berhasil!',
      user: newUser,
    );
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await initialize();

    final normalizedEmail = email.trim().toLowerCase();
    final hashedPassword = _hashPassword(password.trim());
    final users = await getUsers();

    try {
      final user = users.firstWhere(
        (item) =>
            item.email.toLowerCase() == normalizedEmail &&
            item.password == hashedPassword,
      );

      await _storageService.writeCurrentUserEmail(user.email);
      return AuthResult(success: true, user: user);
    } catch (_) {
      return const AuthResult(
        success: false,
        message: 'Email atau password salah.',
      );
    }
  }

  Future<UserModel?> getCurrentUser() async {
    await initialize();

    final currentEmail = await _storageService.readCurrentUserEmail();
    if (currentEmail == null || currentEmail.isEmpty) {
      return null;
    }

    final users = await getUsers();
    for (final user in users) {
      if (user.email.toLowerCase() == currentEmail.toLowerCase()) {
        return user;
      }
    }

    return null;
  }

  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  Future<void> logout() async {
    await _storageService.clearCurrentUserEmail();
  }

  Future<void> _saveUsers(List<UserModel> users) async {
    await _storageService.writeUsers(
      users.map((user) => user.toJson()).toList(),
    );
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
