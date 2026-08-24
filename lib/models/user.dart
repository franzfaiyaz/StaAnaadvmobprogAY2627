class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String accessToken;
  final String refreshToken;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] is Map ? json['user'] as Map<String, dynamic> : json;

    final id = int.tryParse((userData['id'] ?? userData['userId'] ?? 0).toString()) ?? 0;
    final username = (userData['username'] ?? userData['name'] ?? '').toString();
    final email = (userData['email'] ?? '').toString();
    final firstName = (userData['firstName'] ?? userData['first_name'] ?? '').toString();
    final lastName = (userData['lastName'] ?? userData['last_name'] ?? '').toString();
    final gender = (userData['gender'] ?? '').toString();
    final image = (userData['image'] ?? userData['avatar'] ?? '').toString();
    final accessToken = (userData['accessToken'] ?? userData['token'] ?? userData['access_token'] ?? '').toString();
    final refreshToken = (userData['refreshToken'] ?? userData['refresh_token'] ?? '').toString();

    return User(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      image: image,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'token': accessToken,
    };
  }
}
