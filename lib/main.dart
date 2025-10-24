import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';
import 'information_screen.dart';
import 'gender_selection_screen.dart';
import 'calorie_deficit_plan_screen.dart';
import 'deficit_selection_screen.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:user_messaging_platform/user_messaging_platform.dart' as ump;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await setupFirebaseMessaging();

  runApp(const MyApp());

  _initConsentSafely();
}

Future<void> _initConsentSafely() async {
  try {
    final info = await ump.UserMessagingPlatform.instance
      .requestConsentInfoUpdate(ump.ConsentRequestParameters())
      .timeout(const Duration(seconds: 5));
    if (info.formStatus == ump.FormStatus.available) {
      await ump.UserMessagingPlatform.instance
        .showConsentForm()
        .timeout(const Duration(seconds: 10));
    }
  } catch (_) {
  }
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  await messaging.subscribeToTopic('daily');
  await messaging.subscribeToTopic('notificaciones_es_weekly');
  await messaging.subscribeToTopic('notificaciones_es');
  FirebaseMessaging.onMessage.listen((_) {});
}

Future<void> updateLanguageSubscription(String languageCode) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  if (languageCode == 'en') {
    await messaging.unsubscribeFromTopic('notificaciones_es');
    await messaging.subscribeToTopic('notificaciones_en');
    await messaging.unsubscribeFromTopic('notificaciones_es_weekly');
    await messaging.subscribeToTopic('notificaciones_en_weekly');
  } else {
    await messaging.unsubscribeFromTopic('notificaciones_en');
    await messaging.subscribeToTopic('notificaciones_es');
    await messaging.unsubscribeFromTopic('notificaciones_en_weekly');
    await messaging.subscribeToTopic('notificaciones_es_weekly');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _sub;
  bool _isSubscribed = false;
  static const _kIds = <String>{'remove_ads_monthly', 'remove_ads_yearly'};
  List<ProductDetails> _products = [];
  Locale _locale = const Locale('es', 'ES');

  bool get isSubscribed => _isSubscribed;
  void unlockAdsOff() => _unlockAdsOff();

  @override
  void initState() {
    super.initState();
    _loadLocale();
    _loadSubscriptionStatus();
    _initSubscriptions();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale');
    if (code != null) {
      setState(() => _locale = Locale(code));
      await updateLanguageSubscription(code);
    }
  }

  void setLocale(Locale locale) async {
    setState(() => _locale = locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    await updateLanguageSubscription(locale.languageCode);
  }

  Future<void> _loadSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isSubscribed = prefs.getBool('is_subscribed') ?? false);
  }

  Future<void> _initSubscriptions() async {
    final resp = await _iap.queryProductDetails(_kIds);
    setState(() => _products = resp.productDetails);
    _sub = _iap.purchaseStream.listen(_onPurchaseUpdated);
    await _iap.restorePurchases();
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user==null) return;
    final uid = user.uid;
    for (final p in purchases) {
      if ((p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored)
          && _kIds.contains(p.productID)) {
        await _unlockAdsOff();
        final price = _products.firstWhere((x)=>x.id==p.productID).price;
        await FirebaseFirestore.instance
            .collection('usuarios').doc(uid)
            .set({
              'suscribed': true,
              'subscriptionProductPrice': price,
              'subscriptionDate': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
      }
      if (p.pendingCompletePurchase) await _iap.completePurchase(p);
    }
  }

  Future<void> _unlockAdsOff() async {
    setState(() => _isSubscribed = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_subscribed', true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .set({
          'suscribed': true,
          'subscriptionProductPrice': _products.firstWhere((p) => _kIds.contains(p.id)).price,
        }, SetOptions(merge: true));
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit League',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorObservers: [routeObserver],
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  Future<Map<String, dynamic>> _getUserFlowData() async {
    final prefs = await SharedPreferences.getInstance();
    bool flowComplete = prefs.getBool('flowComplete') ?? false;
    String lastScreen = prefs.getString('lastScreen') ?? 'registerScreen';
    String genderString = prefs.getString('gender') ?? Gender.male.name;
    double deficit = prefs.getDouble('deficit') ?? 0.0;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        if (data['flowComplete'] is bool) {
          flowComplete = data['flowComplete'] as bool;
          await prefs.setBool('flowComplete', flowComplete);
        }
        if (data['lastScreen'] is String) {
          lastScreen = data['lastScreen'] as String;
          await prefs.setString('lastScreen', lastScreen);
        }
        if (data['gender'] is String) {
          genderString = data['gender'] as String;
          await prefs.setString('gender', genderString);
        }
        if (data['deficit'] != null) {
          deficit = (data['deficit'] as num).toDouble();
          await prefs.setDouble('deficit', deficit);
        }
      }
    }

    return {
      'flowComplete': flowComplete,
      'lastScreen': lastScreen,
      'genderString': genderString,
      'deficit': deficit,
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapAuth) {
        if (snapAuth.connectionState != ConnectionState.active) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapAuth.data;
        if (user == null) {
          return LoginScreen(gender: Gender.male, deficit: 0.0);
        }
        return FutureBuilder<Map<String, dynamic>>(
          future: _getUserFlowData(),
          builder: (context, snapPrefs) {
            if (snapPrefs.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final data = snapPrefs.data!;
            final gender = Gender.values.firstWhere(
              (g) => g.name == data['genderString'] as String,
              orElse: () => Gender.male,
            );
            final deficit = data['deficit'] as double;
            final flowComplete = data['flowComplete'] as bool;
            final lastScreen = data['lastScreen'] as String;

            if (flowComplete) {
              return MainScreen(gender: gender, deficit: deficit, target: 0.15);
            }
            switch (lastScreen) {
              case 'welcomeScreen':
                return WelcomeScreen();
              case 'informationScreen':
                return InformationScreen();
              case 'genderSelectionScreen':
                return const GenderSelectionScreen();
              case 'calorieDeficitPlanScreen':
                return CalorieDeficitPlanScreen(gender: gender);
              case 'deficitSelectionScreen':
                return DeficitSelectionScreen(gender: gender);
              default:
                return WelcomeScreen();
            }
          },
        );
      },
    );
  }
}

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.authTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              ),
              child: Text(loc.registerButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen(gender: Gender.male, deficit: 0.0)),
              ),
              child: Text(loc.loginButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
