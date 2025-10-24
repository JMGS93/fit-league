import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'welcome_screen.dart';
import 'terms_of_service_screen.dart';
import 'privacy_policy_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/banner_ad_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _isAccepted = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);
    final localizations = AppLocalizations.of(context)!;

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.errorEmptyFields)),
        );
        setState(() => _isLoading = false);
      }
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .set({
          'email': emailController.text.trim(),
          'flowComplete': false,
          'lastScreen': 'welcomeScreen',
        }, SetOptions(merge: true));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastScreen', 'welcomeScreen');
        await prefs.setBool('flowComplete', false);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = localizations.errorGenericRegister;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = localizations.errorEmailAlreadyInUse;
          break;
        case 'invalid-email':
          errorMessage = localizations.errorInvalidEmail;
          break;
        case 'weak-password':
          errorMessage = localizations.errorWeakPassword;
          break;
        case 'operation-not-allowed':
          errorMessage = localizations.errorOperationNotAllowed;
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.errorGenericRegister)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText && !_passwordVisible,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.red),
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.red,
                ),
                onPressed: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const BannerAdWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Transform.translate(
                  offset: const Offset(0, -200),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60, left: 16.0, right: 16.0, bottom: 16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 60,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localizations.registerTitle,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: emailController,
                              hintText: localizations.emailHint,
                              icon: Icons.email,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: passwordController,
                              hintText: localizations.passwordHint,
                              icon: Icons.lock,
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _isAccepted,
                                  onChanged: (value) {
                                    setState(() {
                                      _isAccepted = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.red,
                                  checkColor: Colors.white,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      children: [
                                        TextSpan(
                                          text: localizations
                                              .registerTermsTextPrefix,
                                        ),
                                        TextSpan(
                                          text: "${localizations
                                                  .termsOfServiceLinkText
                                                  .trim()}.",
                                          style: const TextStyle(
                                              color: Colors.red),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const TermsOfServiceScreen(),
                                                ),
                                              );
                                            },
                                        ),
                                        TextSpan(
                                          text: " ${localizations.andText} ",
                                        ),
                                        TextSpan(
                                          text: localizations
                                              .privacyPolicyLinkText,
                                          style: const TextStyle(
                                              color: Colors.red),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const PrivacyPolicyScreen(),
                                                ),
                                              );
                                            },
                                        ),
                                        const TextSpan(text: "."),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading)
                              const Column(
                                children: [
                                  CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.red),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: (!_isLoading && _isAccepted)
                                    ? _register
                                    : null,
                                child:
                                    Text(localizations.createAccountButton),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
              child: BannerAdWidget(),
            ),
          ],
        ),
      ),
    );
  }
}