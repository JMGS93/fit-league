import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'main.dart';
import 'welcome_screen.dart';
import 'information_screen.dart';
import 'gender_selection_screen.dart';
import 'calorie_deficit_plan_screen.dart';
import 'deficit_selection_screen.dart';
import 'home_screen.dart';
import 'deurenberg_calculation_screen.dart';
import 'dart:async';
import 'widgets/banner_ad_widget.dart';

class LoginScreen extends StatefulWidget {
  final Gender gender;
  final double deficit;

  const LoginScreen({
    super.key,
    required this.gender,
    required this.deficit,
  });

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  Future<void> _signIn() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final loc = AppLocalizations.of(context)!;
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorEnterEmailPassword)),
      );
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.invalidEmailFormat)),
      );
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final prefs = await SharedPreferences.getInstance();
      String storedGenderStr = prefs.getString('gender') ?? '';
      double storedDeficit = prefs.getDouble('deficit') ?? 0.0;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['gender'] is String) {
            storedGenderStr = data['gender'];
            await prefs.setString('gender', storedGenderStr);
          }
          if (data['deficit'] != null) {
            storedDeficit = (data['deficit'] as num).toDouble();
            await prefs.setDouble('deficit', storedDeficit);
          }
        }
      }
      final genderEnum = storedGenderStr == loc.genderMale
          ? Gender.male
          : Gender.female;
      bool flowComplete = prefs.getBool('flowComplete') ?? false;
      String lastScreen = prefs.getString('lastScreen') ?? 'welcomeScreen';
      if (user != null) {
        final doc2 = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();
        if (doc2.exists) {
          final data = doc2.data() as Map<String, dynamic>;
          if (data['flowComplete'] is bool) {
            flowComplete = data['flowComplete'] as bool;
            await prefs.setBool('flowComplete', flowComplete);
          }
          if (data['lastScreen'] is String) {
            lastScreen = data['lastScreen'] as String;
            await prefs.setString('lastScreen', lastScreen);
          }
        }
      }
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('flowComplete', flowComplete);
        await prefs.setString('lastScreen', lastScreen);
        await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .set({
            'flowComplete': flowComplete,
            'lastScreen': lastScreen,
          }, SetOptions(merge: true));
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthenticationWrapper()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = loc.errorSignIn;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = loc.errorInvalidEmail;
          break;
        case 'user-disabled':
          errorMessage = loc.errorUserDisabled;
          break;
        case 'user-not-found':
          errorMessage = loc.errorUserNotFound;
          break;
        case 'wrong-password':
          errorMessage = loc.errorWrongPassword;
          break;
        case 'too-many-requests':
          errorMessage = loc.errorTooManyRequests;
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  void _navigateToFlowScreen(
      String lastScreen, Gender storedGender, double storedDeficit) {
    switch (lastScreen) {
      case 'welcomeScreen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen()),
        );
        break;
      case 'informationScreen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => InformationScreen()),
        );
        break;
      case 'genderSelectionScreen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GenderSelectionScreen()),
        );
        break;
      case 'calorieDeficitPlanScreen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CalorieDeficitPlanScreen(gender: storedGender),
          ),
        );
        break;
      case 'deficitSelectionScreen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DeficitSelectionScreen(gender: storedGender),
          ),
        );
        break;
      case 'homeScreen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                HomeScreen(gender: storedGender, deficit: storedDeficit),
          ),
        );
        break;
      case 'deurenbergCalculationScreen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DeurenbergCalculationScreen(
              gender: storedGender,
              deficit: storedDeficit,
              target: 0.15,
            ),
          ),
        );
        break;
      case 'resultScreen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                HomeScreen(gender: storedGender, deficit: storedDeficit),
          ),
        );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen()),
        );
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
                onPressed: () {
                  setState(() => _passwordVisible = !_passwordVisible);
                },
              )
            : null,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<void> _changeLanguage(Locale locale) async {
    BuildContext? dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        );
      },
    );
    await Future.delayed(const Duration(milliseconds: 100));
    MyApp.of(context)?.setLocale(locale);
    Timer(const Duration(seconds: 5), () {
      if (dialogContext != null) Navigator.pop(dialogContext!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            BannerAdWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Transform.translate(
                  offset: const Offset(0, -70),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                await _changeLanguage(
                                    const Locale('en', 'US'));
                              },
                              icon: Image.asset(
                                'assets/uk_flag.png',
                                width: 24,
                                height: 24,
                              ),
                              label: const Text(
                                "ENG",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              height: 20,
                              width: 1,
                              color: Colors.white,
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                await _changeLanguage(
                                    const Locale('es', 'ES'));
                              },
                              icon: Image.asset(
                                'assets/spain_flag.png',
                                width: 24,
                                height: 24,
                              ),
                              label: const Text(
                                "ESP",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Text(
                                localizations.welcome.replaceAll(',', '\n'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(244, 67, 54, 1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.loginPrompt,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        _buildTextField(
                          controller: _emailController,
                          hintText: localizations.emailHint,
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: localizations.passwordHint,
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ResetPasswordScreen()),
                              );
                            },
                            child: Text(
                              localizations.forgotPassword,
                              style: const TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_isLoading)
                          Column(
                            children: const [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        Transform.translate(
                          offset: const Offset(0, -16),
                          child: Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signIn,
                                child: Text(localizations.signInButton),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 19),
                        Transform.translate(
                          offset: const Offset(0, -20),
                          child: Center(
                            child: Text(
                              localizations.noAccount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Transform.translate(
                          offset: const Offset(0, -28),
                          child: Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  RegisterScreen()),
                                        );
                                      },
                                child: Text(localizations.registerButton),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              child: BannerAdWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    final localizations = AppLocalizations.of(context)!;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.resetSuccess),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? localizations.resetError)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(localizations.resetPassword),
        backgroundColor: const Color.fromRGBO(244, 67, 54, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.resetPasswordDescription,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: localizations.emailHint,
                  hintStyle: const TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.email, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    )
                  : ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text(localizations.resetButton),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}