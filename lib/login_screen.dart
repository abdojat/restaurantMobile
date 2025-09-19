import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'sign_up.dart';
import 'services/auth_service.dart';
import 'utils/localization_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LocalizationMixin {
  final TextEditingController phone_numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? passwordError;

  bool get isFormValid {
    return phone_numberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _validateAndLogin() async {
    if (!isFormValid) return;

    setState(() {
      _isLoading = true;
      passwordError = null;
    });

    try {
      final result = await _authService.login(
        phone_number: phone_numberController.text.trim(),
        password: passwordController.text,
      );

      if (result.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(getText('login_successful')),
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
            passwordError = result.errorMessage;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          passwordError = getText('unexpected_error');
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

  InputDecoration inputDecoration(String labelKey, {String? errorText}) {
    return InputDecoration(
      labelText: getText(labelKey),
      errorText: errorText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return withDirectionality(Scaffold(
      appBar: AppBar(
        title: Text(
          getText('login'),
          style: const TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: phone_numberController,
              decoration: InputDecoration(
                labelText: getText('phone_number'),
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
                errorText: phone_numberController.text.isNotEmpty &&
                        !RegExp(r'^\d{10}$')
                            .hasMatch(phone_numberController.text)
                    ? getText('enter_valid_phone')
                    : null,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: inputDecoration(
                'password',
                errorText: passwordError,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed:
                    (isFormValid && !_isLoading) ? _validateAndLogin : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (isFormValid && !_isLoading)
                      ? Colors.teal
                      : Colors.grey[400],
                ),
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
                    : Text(getText('login')),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${getText('dont_have_account')} '),
                InkWell(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      getText('sign_up'),
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
