import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function(String username, String email) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter username' : null,
                onSaved: (val) => username = val!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter email';
                  final emailRegex = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$'); // Simple email validation
                  if (!emailRegex.hasMatch(val)) return 'Enter valid email';
                  return null;
                },
                onSaved: (val) => email = val!.trim(),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onLogin(username, email);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
