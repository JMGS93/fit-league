import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';             
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'account_screen.dart';
import 'language_dialog.dart';
import 'login_screen.dart';
import 'dynamic_dish_calculator_screen.dart';
import 'Privacy_Policy_Screen.dart';
import 'terms_of_service_screen.dart';
import 'feedback_dialog.dart';
import 'subscription_screen.dart';
import 'widgets/banner_ad_widget.dart';
import 'gender_selection_screen.dart';                                    

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _dynamicDishCalculator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DynamicDishCalculatorScreen(),
      ),
    );
  }

  void _miCuenta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountScreen()),
    );
  }

  void _idiomas(BuildContext context) {
    showLanguageDialog(context);
  }

  void _politicaPrivacidad(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
    );
  }

  void _terminosServicio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
    );
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    final storedGenderName = prefs.getString('gender') ?? Gender.male.name;
    final storedGender = Gender.values.firstWhere(
      (g) => g.name == storedGenderName,
      orElse: () => Gender.male,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          gender: storedGender,
          deficit: 0.0,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title,
      {bool useDivider = true, bool addTopSpacing = false}) {
    const headerTextStyle = TextStyle(
      color: Color.fromARGB(255, 119, 119, 119),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    final dividerColor = Colors.grey[700];
    return Column(
      children: [
        if (addTopSpacing) const SizedBox(height: 1),
        if (!useDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Center(
              child: Text(title.toUpperCase(), style: headerTextStyle),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Row(
              children: [
                Expanded(child: Divider(color: dividerColor, thickness: 1.0)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(title.toUpperCase(), style: headerTextStyle),
                ),
                Expanded(child: Divider(color: dividerColor, thickness: 1.0)),
              ],
            ),
          ),
        const SizedBox(height: 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          localizations.menuTitle,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 7.0),
        children: [
          Container(height: 49, child: BannerAdWidget()),
          _buildSectionHeader(localizations.menuTools),
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            leading: const Icon(Icons.calculate, color: Colors.red, size: 30),
            title: Text(
              localizations.menuDynamicDishCalculator,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () => _dynamicDishCalculator(context),
          ),
          _buildSectionHeader(localizations.menuConfiguration,
              addTopSpacing: true),
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            leading: const Icon(Icons.language, color: Colors.red, size: 30),
            title: Text(
              localizations.menuLanguage,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () => _idiomas(context),
          ),
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            leading:
                const Icon(Icons.account_circle, color: Colors.red, size: 30),
            title: Text(
              localizations.menuAccount,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () => _miCuenta(context),
          ),
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            leading: const Icon(Icons.logout, color: Colors.red, size: 30),
            title: Text(
              localizations.menuLogout,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () => _cerrarSesion(context),
          ),
          _buildSectionHeader(localizations.menuInformation, addTopSpacing: true),
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            leading: const Icon(Icons.description, color: Colors.red, size: 30),
            title: Text(
              localizations.termsOfServiceTitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () => _terminosServicio(context),
          ),
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            leading:
                const Icon(Icons.privacy_tip, color: Colors.red, size: 30),
            title: Text(
              localizations.privacyPolicyTitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () => _politicaPrivacidad(context),
          ),
          _buildSectionHeader(localizations.menuFeedback, addTopSpacing: true),
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            leading: const Icon(Icons.feedback, color: Colors.red, size: 30),
            title: Text(
              localizations.feedbackOptionText,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () => FeedbackDialog.mostrarFeedbackDialog(context),
          ),
          const SizedBox(height: 10),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 21, 95, 255),
                padding: const EdgeInsets.symmetric(vertical: 9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber, size: 36),
                  const SizedBox(width: 6),
                  Text(
                    localizations.menuSubscribeOption,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(height: 49, child: BannerAdWidget()),
        ],
      ),
    );
  }
}
