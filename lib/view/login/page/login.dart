import 'package:flutter/material.dart';
import 'package:home_ease/view/home.dart';
import 'package:home_ease/view/login/service/login_service.dart';
import 'package:home_ease/view/register/page/register.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() => _isLoading = true);

      try {
        final responseMessage = await userLoginService(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (responseMessage.status == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Login successful')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseMessage.message ?? "Unknown error")),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 237, 245),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/home_ease_logo.png',
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.3,
                ),
                SizedBox(height: screenHeight * 0.02),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(41, 107, 239, 1),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      _buildInputLabel('Email', screenWidth),
                      _buildTextField(_emailController, Icons.email_outlined,
                          'Please enter your email', 'Enter a valid email',
                          regex: r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]'),
                      SizedBox(height: screenHeight * 0.018),
                      _buildInputLabel('Password', screenWidth),
                      _buildPasswordField(),
                      SizedBox(height: screenHeight * 0.03),
                      _buildLoginButton(screenWidth),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildSignupRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text, double width) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: width * 0.045,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(41, 107, 239, 1),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon,
      String emptyMessage, String invalidMessage,
      {String? regex}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return emptyMessage;
        if (regex != null && !RegExp(regex).hasMatch(value)) return invalidMessage;
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      validator: (value) => value == null || value.isEmpty
          ? 'Please enter your password'
          : value.length < 6
              ? 'Password must be at least 6 characters'
              : null,
    );
  }

  Widget _buildLoginButton(double width) {
    return SizedBox(
      width: width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(41, 107, 239, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _isLoading ? null : _loginUser,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Widget _buildSignupRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserRegistration()),
          ),
          child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(41, 107, 239, 1))),
        ),
      ],
    );
  }
}
