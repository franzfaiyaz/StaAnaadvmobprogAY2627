import 'package:flutter/material.dart';

import '../services/user_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  LoginType _loginType = LoginType.firebase;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Enhancement 2: Custom sign-in UI using UserService and authentication logic
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await UserService().signIn(
        _usernameController.text.trim(),
        _passwordController.text,
        loginType: _loginType,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pushReplacementNamed(context, '/home', arguments: response);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final message = e.toString().startsWith('Exception: ')
          ? e.toString().substring('Exception: '.length)
          : e.toString();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/NUBDEXCHANGE_LOGO.PNG',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF302F2F),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SegmentedButton<LoginType>(
                    segments: const [
                      ButtonSegment(
                        value: LoginType.dummyJson,
                        label: Text('DummyJSON'),
                      ),
                      ButtonSegment(
                        value: LoginType.firebase,
                        label: Text('Firebase'),
                      ),
                    ],
                    selected: {_loginType},
                    onSelectionChanged: _isLoading
                        ? null
                        : (selection) =>
                              setState(() => _loginType = selection.first),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _loginType == LoginType.firebase
                        ? 'Use the email and password from your Firebase account.'
                        : 'Use a DummyJSON account, such as emilys / emilyspass.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF5A5A5A)),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? _loginType == LoginType.firebase
                              ? 'Please enter your email'
                              : 'Please enter your username'
                        : null,
                    decoration: InputDecoration(
                      labelText: _loginType == LoginType.firebase
                          ? 'Email'
                          : 'Username',
                      hintText: _loginType == LoginType.firebase
                          ? 'Enter email'
                          : 'Enter username',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your password'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C3F79),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushNamed(context, '/signup'),
                    child: const Text('Create Firebase account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
