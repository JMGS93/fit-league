import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/banner_ad_widget.dart';
import 'gender_selection_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? "";
    }
  }

  Future<void> _saveChanges() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (_emailController.text.trim() != user.email) {
          await user.verifyBeforeUpdateEmail(_emailController.text.trim());
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .update({'email': _emailController.text.trim()});
        }
        if (_passwordController.text.trim().isNotEmpty) {
          await user.updatePassword(_passwordController.text.trim());
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.accountUpdated)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.errorUpdatingAccount(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final localizations = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final TextEditingController _passCtrl = TextEditingController();
        bool _passVisible = false;
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              localizations.enterPasswordToDelete,
              style: const TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _passCtrl,
                  obscureText: !_passVisible,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: localizations.password,
                    labelStyle: const TextStyle(color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.red,
                      ),
                      onPressed: () => setState(() => _passVisible = !_passVisible),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Colors.deepPurpleAccent, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: Text(localizations.cancel,
                    style: const TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(244, 67, 54, 1)),
                onPressed: () => Navigator.of(ctx).pop(_passCtrl.text.trim()),
                child: Text(localizations.confirm,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
    if (password == null || password.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(244, 67, 54, 1),
        ),
      ),
    );

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);

      final db = FirebaseFirestore.instance;
      final userDocRef = db.collection('usuarios').doc(user.uid);

      final mealsSnap = await userDocRef.collection('savedMeals').get();
      final batch = db.batch();
      for (var mealDoc in mealsSnap.docs) {
        batch.delete(mealDoc.reference);
      }
      batch.delete(userDocRef);
      await batch.commit();

      await user.delete();

      Navigator.of(context, rootNavigator: true).pop();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      final storedGenderName = prefs.getString('gender') ?? Gender.male.name;
      final storedGender = Gender.values.firstWhere(
        (g) => g.name == storedGenderName,
        orElse: () => Gender.male,
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black,
          title: Text(localizations.accountDeletedDialogTitle,
              style: const TextStyle(color: Colors.white)),
          content: Text(localizations.accountDeletedDialogMessage,
              style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LoginScreen(gender: storedGender, deficit: 0.0),
                  ),
                );
              },
              child: Text(localizations.ok,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.errorDeletingAccount(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(localizations.accountTitle,
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const BannerAdWidget(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: const Color.fromRGBO(244, 67, 54, 1),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          localizations.accountChangePassword,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 119, 119, 119),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: localizations.accountEmail,
                            labelStyle: const TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(244, 67, 54, 1)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(244, 67, 54, 1)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            fillColor: Colors.grey[900],
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: localizations.accountNewPassword,
                            labelStyle: const TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(244, 67, 54, 1)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(244, 67, 54, 1)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            fillColor: Colors.grey[900],
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 236, 236, 236),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(localizations.accountSaveChanges),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          localizations.accountDeleteAccount,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 119, 119, 119),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _deleteAccount,
                          child: Text(
                            localizations.accountDelete,
                            style: const TextStyle(
                              color: Color.fromRGBO(244, 67, 54, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SizedBox(
        height: 60,
        child: BannerAdWidget(),
      ),
    );
  }
}