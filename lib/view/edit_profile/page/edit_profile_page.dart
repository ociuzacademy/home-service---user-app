import 'package:flutter/material.dart';
import 'package:home_ease/view/edit_profile/service/edit_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Validation patterns
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  final RegExp phoneRegex = RegExp(r'^[0-9]{10,15}$');
  final RegExp passwordRegex = RegExp(r'^[A-Za-z\d]{1,6}$');

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await editProfileService(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        password: passwordController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (response.detail == 'Profile updated successfully.') {
        _showSnackBar('Profile updated successfully!', isError: false);
      } else {
        _showSnackBar("Failed to update profile");
      }
    } catch (e) {
      _showSnackBar('An error occurred: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Username", usernameController, isRequired: true),
              _buildEmailField(),
              _buildTextField("Address", addressController, isRequired: false),
              _buildPasswordField(),
              _buildPhoneField(),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Save", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false, required bool isRequired}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label + (isRequired ? '' : ' (Optional)'),
          labelStyle: TextStyle(color: Colors.blueAccent),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.4)),
          ),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.blueAccent),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.4)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Phone Number (Optional)',
          labelStyle: TextStyle(color: Colors.blueAccent),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.4)),
          ),
          prefix: Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text('+', style: TextStyle(color: Colors.blueAccent)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null; // Optional
          }
          if (!phoneRegex.hasMatch(value)) {
            return 'Please enter a valid phone number (10-15 digits)';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.blueAccent),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.4)),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (!passwordRegex.hasMatch(value)) {
            return 'Password must be up to 6 characters (letters or digits only)';
          }

          return null;
        },
      ),
    );
  }
}
