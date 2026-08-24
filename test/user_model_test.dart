import 'package:flutter_test/flutter_test.dart';
import 'package:staana_advmobprog/models/user.dart';
import 'package:staana_advmobprog/services/user_service.dart';

void main() {
  test('User.fromJson maps auth fields correctly', () {
    final user = User.fromJson({
      'id': 7,
      'username': 'emilys',
      'email': 'emily.johnson@x.dummy',
      'firstName': 'Emily',
      'lastName': 'Johnson',
      'gender': 'female',
      'image': 'https://example.com/avatar.png',
      'token': 'abc123',
    });

    expect(user.id, 7);
    expect(user.username, 'emilys');
    expect(user.email, 'emily.johnson@x.dummy');
    expect(user.firstName, 'Emily');
    expect(user.lastName, 'Johnson');
    expect(user.gender, 'female');
    expect(user.image, 'https://example.com/avatar.png');
    expect(user.accessToken, 'abc123');
  });

  test(
    'UserService.parseLoginError shows a readable invalid-credentials message',
    () {
      expect(
        UserService.parseLoginError('{"message":"Invalid credentials"}'),
        'Invalid credentials',
      );
      expect(
        UserService.parseLoginError('{"error":"Invalid credentials"}'),
        'Invalid credentials',
      );
      expect(
        UserService.parseLoginError('Invalid credentials'),
        'Invalid credentials',
      );
      expect(
        UserService.parseLoginError(''),
        'Unable to sign in. Please check your credentials.',
      );
    },
  );
}
