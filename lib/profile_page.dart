import 'package:flutter/material.dart';
import 'PaymentPage.dart';
import 'profile_components/give_rating_page.dart';
import 'profile_components/help_report_page.dart';
import 'profile_components/language_page.dart';
import 'profile_components/news_services_page.dart';
import 'profile_components/privacy_policy_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'models/user_model.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/language_service.dart';
import 'login_screen.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({super.key, required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel _user;
  File? _selectedImage;
  bool _isUpdating = false;
  final AuthService _authService = AuthService();
  final LanguageService _languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _languageService.initialize();
    _languageService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showEditBottomSheet() {
    final nameController = TextEditingController(text: _user.name);
    final emailController = TextEditingController(text: _user.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _languageService.getText('edit_profile'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : AssetImage(_user.avatarPath ?? 'images/profileImage.png')
                        as ImageProvider,
                child: const Icon(Icons.edit, size: 24, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: _languageService.getText('name'),
                  floatingLabelStyle:
                      const TextStyle(color: Color(0xFF008C8C), fontSize: 18),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF008C8C)))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: _languageService.getText('email'),
                  floatingLabelStyle:
                      const TextStyle(color: Color(0xFF008C8C), fontSize: 18),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF008C8C)))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUpdating
                  ? null
                  : () => _updateProfile(nameController, emailController),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isUpdating ? Colors.grey : Color(0xFF008C8C),
                  foregroundColor: Colors.white),
              child: _isUpdating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _languageService.getText('save'),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile(TextEditingController nameController,
      TextEditingController emailController) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final updatedUser = await ApiService.updateProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        avatarFile: _selectedImage,
      );

      setState(() {
        _user = updatedUser;
        _selectedImage = null; // Reset selected image after successful upload
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_languageService.getText('profile_updated')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_languageService.getText('logout')),
        content: Text(_languageService.getText('logout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_languageService.getText('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFC34D33),
            ),
            child: Text(_languageService.getText('logout')),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Perform logout
        await _authService.logout();

        // Close loading dialog
        if (mounted) Navigator.of(context).pop();

        // Navigate to login screen and clear navigation stack
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        // Close loading dialog if still open
        if (mounted) Navigator.of(context).pop();

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _languageService.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _languageService.getText('profile'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : AssetImage(
                                _user.avatarPath ?? 'images/profileImage.png')
                            as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_user.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text(_user.email,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _showEditBottomSheet,
                    child: Row(
                      children: [
                        const Icon(Icons.edit, color: Color(0xFF66676E), size: 17),
                        const SizedBox(width: 8),
                        Text(
                          _languageService.getText('edit'),
                          style: const TextStyle(
                            color: Color(0xFF66676E),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                const SizedBox(height: 30),
                Text(_languageService.getText("account"),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 15),
                _buildProfileOption(
                  icon: Icons.payment,
                  label: _languageService.getText('payment_method'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Paymentpage()),
                  ),
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.shopping_cart,
                  label: _languageService.getText('my_cart'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage()),
                  ),
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.report,
                  label: _languageService.getText('help_report'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpAndReportPage()),
                  ),
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.language,
                  label: _languageService.getText('language'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LanguagePage()),
                  ),
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.favorite,
                  label: _languageService.getText('favorite'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesPage()),
                  ),
                ),
                _buildDivider(),
                const SizedBox(height: 30),
                Text(_languageService.getText("more_info"),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 20),
                _buildProfileOption(
                  icon: Icons.privacy_tip,
                  label: _languageService.getText('privacy_policy'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                  ),
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.article,
                  label: _languageService.getText('news_services'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NewsAndServicesPage()),
                  ),
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.star,
                  label: _languageService.getText('give_rating'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GiveRatingPage()),
                  ),
                ),
                _buildDivider(),
                const SizedBox(height: 30),
                Center(
                  child: TextButton(
                    onPressed: _handleLogout,
                    child: Text(
                      _languageService.getText('logout'),
                      style: const TextStyle(
                        color: Color(0xFFC34D33),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(icon, size: 26, color: const Color(0xFF66676E)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFE8E8E8),
      thickness: 1,
      height: 0.5,
    );
  }
}
