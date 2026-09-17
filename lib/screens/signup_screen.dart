import 'package:flutter/material.dart';

import '../services/user_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    for (final controller in [
      _firstNameController,
      _lastNameController,
      _ageController,
      _contactController,
      _usernameController,
      _emailController,
      _passwordController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value, String label) {
    return value == null || value.trim().isEmpty ? '$label is required' : null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Use an uppercase letter and a number';
    }
    return null;
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final userData = await UserService().createAccount(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        age: int.parse(_ageController.text),
        contactNo: _contactController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
        arguments: userData,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(UserService.parseLoginError(error))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Firebase Account')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _field(_firstNameController, 'First name', 'fName'),
              _field(_lastNameController, 'Last name', 'lName'),
              _field(
                _ageController,
                'Age',
                'age',
                keyboardType: TextInputType.number,
                validator: (value) {
                  final required = _required(value, 'Age');
                  if (required != null) return required;
                  final age = int.tryParse(value!.trim());
                  return age == null || age < 13 || age > 120
                      ? 'Enter an age from 13 to 120'
                      : null;
                },
              ),
              _field(
                _contactController,
                'Contact number',
                'contactNo',
                keyboardType: TextInputType.phone,
              ),
              _field(_usernameController, 'Username', 'username'),
              _field(
                _emailController,
                'Email address',
                'emailAddress',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final required = _required(value, 'Email address');
                  if (required != null) return required;
                  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!)
                      ? null
                      : 'Enter a valid email address';
                },
              ),
              _field(
                _passwordController,
                'Password',
                'password',
                obscureText: _obscurePassword,
                validator: _validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createAccount,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Create account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String semanticName, {
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator ?? (value) => _required(value, label),
        decoration: InputDecoration(
          labelText: label,
          hintText: semanticName,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
