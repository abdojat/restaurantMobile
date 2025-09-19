import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'login_screen.dart';
import 'services/auth_service.dart';
import 'utils/localization_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with LocalizationMixin {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  bool isFormValid() {
    return nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate() || !isFormValid()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.register(
        name: nameController.text.trim(),
        phone_number: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );

      if (result.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(getText('registration_successful')),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homepage()),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = result.errorMessage;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = getText('unexpected_error');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return withDirectionality(Scaffold(
      appBar: AppBar(
        title: Text(
          getText('sign_up'),
          style: const TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: getText('name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? getText('enter_your_name') : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: getText('phone'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  errorText: phoneController.text.isNotEmpty &&
                          !RegExp(r'^\d{10}$').hasMatch(phoneController.text)
                      ? getText('enter_valid_phone')
                      : null,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: getText('email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: getText('password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: getText('confirm_password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFormValid() ? Colors.teal : Colors.grey[400],
                  ),
                  onPressed:
                      (isFormValid() && !_isLoading) ? _handleSignUp : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          getText('sign_up_now'),
                          style: const TextStyle(color: Colors.black),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${getText('already_have_account')} '),
                  InkWell(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        getText('login'),
                        style: const TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
