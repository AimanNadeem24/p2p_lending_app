import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'role_selection.dart'; // ✅ Import RoleSelectionScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(); // ✅ Added full name
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ✅ Full Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value!.isEmpty ? "Full name is required" : null,
              ),

              // ✅ Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return "Email is required";
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),

              // ✅ Password field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Password is required" : null,
              ),

              const SizedBox(height: 20),

              // ✅ Sign In button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', true);
                    await prefs.setString('userName', _nameController.text);
                    // For now, just navigate to RoleSelectionScreen
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoleSelectionScreen(
                            userName: _nameController.text, // pass full name
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Sign In"),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text("Don't have an account? Get Started"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
