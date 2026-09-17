import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

enum LoginType { dummyJson, firebase }

class UserService {
  Map<String, dynamic> data = {};

  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  static String parseLoginError(dynamic error) {
    final raw = error?.toString() ?? '';
    if (raw.trim().isEmpty) {
      return 'Unable to sign in. Please check your credentials.';
    }

    String cleaned = raw.replaceFirst('Exception: ', '').trim();

    if (cleaned.isEmpty) {
      return 'Unable to sign in. Please check your credentials.';
    }

    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is Map<String, dynamic>) {
        for (final key in ['message', 'error', 'detail', 'errorMessage']) {
          final value = decoded[key];
          if (value != null && value.toString().trim().isNotEmpty) {
            return value.toString();
          }
        }
      }
    } catch (_) {
      // Ignore JSON decode errors and fall back to original text.
    }

    final lower = cleaned.toLowerCase();
    if (lower.contains('invalid credentials')) {
      return 'Invalid credentials';
    }
    if (lower.contains('username') || lower.contains('password')) {
      return 'Unable to sign in. Please check your credentials.';
    }

    return cleaned;
  }

  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    late final Response response;
    try {
      response = await post(
        Uri.parse('$host/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 60,
        }),
      );
    } on Exception catch (error) {
      throw Exception('DummyJSON could not be reached: $error');
    }

    if (response.statusCode == 200) {
      data = jsonDecode(response.body) as Map<String, dynamic>;
      data['loginType'] = LoginType.dummyJson.name;
      await saveUserData(data);
      return data;
    }

    throw Exception(parseLoginError(response.body));
  }

  Future<Map<String, dynamic>> signIn(
    String identifier,
    String password, {
    LoginType loginType = LoginType.dummyJson,
  }) async {
    if (loginType == LoginType.dummyJson) {
      return loginUser(identifier, password);
    }

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: identifier.trim(),
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) throw Exception('Unable to sign in.');
      final token = await firebaseUser.getIdToken(true);
      final userData = _firebaseUserData(firebaseUser, token);
      await saveUserData(userData);
      return userData;
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw Exception(_firebaseErrorMessage(error));
    }
  }

  Future<Map<String, dynamic>> createAccount({
    required String firstName,
    required String lastName,
    required int age,
    required String contactNo,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) throw Exception('Unable to create account.');

      await firebaseUser.updateDisplayName('$firstName $lastName'.trim());
      await firebaseUser.reload();
      final refreshedUser = _firebaseAuth.currentUser ?? firebaseUser;
      final token = await refreshedUser.getIdToken(true);
      final userData = _firebaseUserData(refreshedUser, token)
        ..addAll({
          'firstName': firstName.trim(),
          'lastName': lastName.trim(),
          'age': age,
          'contactNo': contactNo.trim(),
          'username': username.trim(),
        });
      await saveUserData(userData);
      return userData;
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw Exception(_firebaseErrorMessage(error));
    }
  }

  Future<void> updateUsername(String username) async {
    final trimmedUsername = username.trim();
    if (trimmedUsername.isEmpty) throw Exception('Username is required.');

    final prefs = await SharedPreferences.getInstance();
    if (await _currentLoginType() == LoginType.firebase) {
      await _firebaseAuth.currentUser?.updateDisplayName(trimmedUsername);
    }
    await prefs.setString('username', trimmedUsername);
  }

  Future<void> resetPasswordFromCurrentPassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('A Firebase account is required to change the password.');
    }

    try {
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      await _refreshFirebaseToken(user);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw Exception(_firebaseErrorMessage(error));
    }
  }

  Future<void> deleteAccount() async {
    final loginType = await _currentLoginType();
    if (loginType == LoginType.firebase && _firebaseAuth.currentUser != null) {
      try {
        await _firebaseAuth.currentUser!.delete();
      } on firebase_auth.FirebaseAuthException catch (error) {
        throw Exception(_firebaseErrorMessage(error));
      }
    }
    await logout();
  }

  // Enhancement 3: Save the authenticated user to SharedPreferences.
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final user = User.fromJson(userData);

    await prefs.setInt('id', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
    await prefs.setString('firstName', user.firstName);
    await prefs.setString('lastName', user.lastName);
    await prefs.setString('gender', user.gender);
    await prefs.setString('image', user.image);
    await prefs.setString('accessToken', user.accessToken);
    await prefs.setString('refreshToken', user.refreshToken);
    await prefs.setInt('age', user.age);
    await prefs.setString('contactNo', user.contactNo);
    await prefs.setString(
      'loginType',
      userData['loginType']?.toString() ?? LoginType.dummyJson.name,
    );
    await prefs.setString('firebaseUid', user.firebaseUid);

    if (userData.containsKey('token')) {
      await prefs.setString('token', userData['token']?.toString() ?? '');
    } else if (user.accessToken.isNotEmpty) {
      await prefs.setString('token', user.accessToken);
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'id': prefs.getInt('id') ?? 0,
      'username': prefs.getString('username') ?? '',
      'email': prefs.getString('email') ?? '',
      'firstName': prefs.getString('firstName') ?? '',
      'lastName': prefs.getString('lastName') ?? '',
      'gender': prefs.getString('gender') ?? '',
      'image': prefs.getString('image') ?? '',
      'accessToken': prefs.getString('accessToken') ?? '',
      'refreshToken': prefs.getString('refreshToken') ?? '',
      'token': prefs.getString('token') ?? prefs.getString('accessToken') ?? '',
      'age': prefs.getInt('age') ?? 0,
      'contactNo': prefs.getString('contactNo') ?? '',
      'loginType': prefs.getString('loginType') ?? LoginType.dummyJson.name,
      'firebaseUid': prefs.getString('firebaseUid') ?? '',
    };
  }

  Future<User> getUserModel() async {
    final userData = await getUserData();
    return User.fromJson(userData);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loginType') == LoginType.firebase.name) {
      final user = _firebaseAuth.currentUser;
      if (user == null) return false;
      await _refreshFirebaseToken(user);
      return true;
    }
    final token = prefs.getString('accessToken') ?? prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }

  Future<void> logout() => signOut();

  Future<LoginType> _currentLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loginType') == LoginType.firebase.name
        ? LoginType.firebase
        : LoginType.dummyJson;
  }

  Map<String, dynamic> _firebaseUserData(
    firebase_auth.User user,
    String? token,
  ) {
    return {
      'id': 0,
      'username': user.displayName ?? '',
      'email': user.email ?? '',
      'firstName': '',
      'lastName': '',
      'image': user.photoURL ?? '',
      'accessToken': token ?? '',
      'refreshToken': '',
      'firebaseUid': user.uid,
      'loginType': LoginType.firebase.name,
    };
  }

  Future<void> _refreshFirebaseToken(firebase_auth.User user) async {
    final token = await user.getIdToken(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token ?? '');
    await prefs.setString('token', token ?? '');
  }

  String _firebaseErrorMessage(firebase_auth.FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Firebase email or password is incorrect.';
      case 'email-already-in-use':
        return 'This email already has a Firebase account.';
      case 'operation-not-allowed':
        return 'Enable Email/Password sign-in in the Firebase Console.';
      case 'weak-password':
        return 'Firebase rejected the password because it is too weak.';
      default:
        return error.message ?? 'Firebase authentication failed.';
    }
  }
}
