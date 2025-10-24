import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nuevo_proyecto/recipe_library_screen.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'result_screen.dart';
import 'login_screen.dart';
import 'menu_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'deficit_selection_screen.dart';
import 'nutritional_education_screen.dart';
import 'meal_calories_adjustment_screen.dart';
import 'custom_meal_screen.dart';
import 'widgets/interstitial_ad_manager.dart';
import 'gender_selection_screen.dart';
import 'widgets/exercise_item.dart';
import 'utils/exercise_video_mapping.dart';

class MainScreen extends StatefulWidget {
  final Gender gender;
  final double deficit;
  final double target;

  const MainScreen({
    super.key,
    required this.gender,
    required this.deficit,
    this.target = 0.15,
  });

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late InterstitialAdManager _interstitialAdManager;
  late String userGender;
  late double userDeficit;
  late double _target;

  late String email;
  late String resultado;
  late String diasTotales;
  late double masaMagra;
  late double masaGrasa;
  bool isLoading = true;
  int _selectedIndex = 0;
  late double _grasaCorporal;
  late double masaMagraInicial;
  late double pesoInicial;
  late double _grasaCorporalInicial;
  double? _lastGrasaCorporal;
  bool _menuAdjustedManually = false;

  double pesoEliminar = 0.0;
  double caloriasTotales = 0.0;
  double _pesoFinalObjetivo = 0.0;

  Map<String, dynamic> menu = {};

  @override
  void initState() {
    super.initState();
    _loadTarget();
    _target = widget.target;
    _loadUserData();
    _loadLastGrasaCorporal();
    _interstitialAdManager = InterstitialAdManager();
    _interstitialAdManager.loadAd();
  }

  Future<void> _showTrainingInterstitialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final DateTime today = DateTime.now();
    final String todayString = "${today.year}-${today.month}-${today.day}";
    final String? lastShown = prefs.getString("lastTrainingInterstitialDate");

    if (lastShown != todayString) {
      _interstitialAdManager.showAd(context);
      await prefs.setString("lastTrainingInterstitialDate", todayString);
    }
  }

  Future<void> _loadLastGrasaCorporal() async {
    final prefs = await SharedPreferences.getInstance();
    double? storedValue = prefs.getDouble("lastGrasaCorporal");
    if (storedValue != null) {
      _lastGrasaCorporal = storedValue;
    }
  }

  Future<void> _loadTarget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double? savedTarget = prefs.getDouble("target");
      if (savedTarget != null) {
        if (!mounted) return;
        setState(() {
          _target = savedTarget;
        });
      }
    } catch (error, stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.updateError)),
        );
      }
      developer.log('Error loading target: $error', stackTrace: stackTrace);
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        userGender = prefs.getString('gender') ?? widget.gender.name;
        userDeficit = prefs.getDouble('deficit') ?? widget.deficit;
      });
    } catch (error, stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.updateError)),
        );
      }
      developer.log('Error loading user data from SharedPreferences: $error',
          stackTrace: stackTrace);
    }
    _getUserData();
  }

  Future<Map<String, dynamic>> _loadMealAdjustments() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          if (data.containsKey('desayunoCalories') &&
              data.containsKey('almuerzoCalories') &&
              data.containsKey('meriendaCalories') &&
              data.containsKey('cenaCalories')) {
            final bool manualAdjusted = data['menuAdjustedManually'] ?? false;
            final double storedDeficit = data['manualDeficit'] != null
                ? double.tryParse(data['manualDeficit'].toString()) ?? 0.0
                : 0.0;
            if (manualAdjusted && (storedDeficit == userDeficit)) {
              if (mounted) {
                setState(() {
                  _menuAdjustedManually = true;
                });
              }
              return {
                "desayunoCalories": data['desayunoCalories'],
                "almuerzoCalories": data['almuerzoCalories'],
                "meriendaCalories": data['meriendaCalories'],
                "cenaCalories": data['cenaCalories'],
              };
            } else {
              if (mounted) {
                setState(() {
                  _menuAdjustedManually = false;
                });
              }
            }
          }
        }
      } catch (e, stackTrace) {
        developer.log(
            'Error loading meal adjustments from Firestore: $e',
            stackTrace: stackTrace);
      }
    }
    final prefs = await SharedPreferences.getInstance();
    int? desayuno = prefs.getInt("desayunoCalories");
    int? almuerzo = prefs.getInt("almuerzoCalories");
    int? merienda = prefs.getInt("meriendaCalories");
    int? cena = prefs.getInt("cenaCalories");
    if (desayuno != null &&
        almuerzo != null &&
        merienda != null &&
        cena != null) {
      return {
        "desayunoCalories": desayuno,
        "almuerzoCalories": almuerzo,
        "meriendaCalories": merienda,
        "cenaCalories": cena,
      };
    } else {
      final double baseCalories = (userGender.toLowerCase() == 'hombre' ||
              userGender.toLowerCase() == 'male')
          ? 2800.0
          : 2200.0;
      final double totalCalories = baseCalories - userDeficit;
      return _getMenu(totalCalories);
    }
  }

  Future<void> _getUserData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docRef =
            FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          if (!mounted) return;

          setState(() {
            email = data['email'] ?? AppLocalizations.of(context)!.notAvailable;
            resultado = data['result'] ?? '0';
            diasTotales = data['diasTotales'] ?? '0';

            masaMagra =
                double.tryParse(data['masaMagra'].toString()) ?? 0.0;
            masaGrasa =
                double.tryParse(data['masaGrasa'].toString()) ?? 0.0;

            masaMagraInicial = data['masaMagraInicial'] != null
                ? double.tryParse(data['masaMagraInicial'].toString()) ??
                    masaMagra
                : masaMagra;

            pesoInicial = data['pesoInicial'] != null
                ? double.tryParse(data['pesoInicial'].toString()) ?? 0.0
                : 0.0;

            userGender = data['gender'] ?? widget.gender.name;
            userDeficit =
                double.tryParse(data['deficit'].toString()) ?? widget.deficit;

            _grasaCorporalInicial = data['grasaCorporalInicial'] != null
                ? double.tryParse(
                        data['grasaCorporalInicial'].toString()) ??
                    0.0
                : 0.0;

            _grasaCorporal = data['grasaCorporal'] != null
                ? double.tryParse(data['grasaCorporal'].toString()) ??
                    _grasaCorporalInicial
                : _grasaCorporalInicial;

            pesoEliminar = data['pesoEliminar'] != null
                ? double.tryParse(data['pesoEliminar'].toString()) ?? 0.0
                : 0.0;
            caloriasTotales = data['caloriasTotales'] != null
                ? double.tryParse(data['caloriasTotales'].toString()) ?? 0.0
                : 0.0;

            _pesoFinalObjetivo = data['pesoFinalObjetivo'] != null
                ? double.tryParse(data['pesoFinalObjetivo'].toString()) ?? 0.0
                : 0.0;
          });

          if (data['grasaCorporalInicial'] == null) {
            try {
              await docRef.update({
                'grasaCorporalInicial': _grasaCorporal,
              });
            } catch (updateError, updateStack) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.updateError)),
                );
              }
              developer.log(
                  'Error updating grasaCorporalInicial: $updateError',
                  stackTrace: updateStack);
            }
            if (data['deficit'] == null) {
              try {
                await docRef.update({'deficit': widget.deficit});
              } catch (updateError, updateStack) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.updateError)),
                  );
                }
                developer.log('Error updating deficit: $updateError',
                    stackTrace: updateStack);
              }
            }
          }
        }
      } catch (e, stackTrace) {
        developer.log('Error getting user data: $e', stackTrace: stackTrace);
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              gender: widget.gender,
              deficit: widget.deficit,
            ),
          ),
        );
      }
      return;
    }

    await Future.delayed(Duration(seconds: 3));
    double previousValue = _lastGrasaCorporal ?? _grasaCorporalInicial;
    if (_grasaCorporal != previousValue) {
      _mostrarFelicitationDialog(
          _grasaCorporal, diasTotales, previous: previousValue);
    }
    _lastGrasaCorporal = _grasaCorporal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("lastGrasaCorporal", _lastGrasaCorporal ?? 0.0);
    _loadMealAdjustments().then((adjustments) {
      if (mounted) {
        setState(() {
          menu = adjustments;
        });
      }
    });
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  double _extractGrasaCorporal(String resultado) {
    final regex = RegExp(r'(\d+(\.\d+)?)');
    final match = regex.firstMatch(resultado);
    return match != null ? double.tryParse(match.group(0)!) ?? 0.0 : 0.0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _mostrarFelicitationDialog(double nuevoIGC, String diasTotales,
      {required double previous}) {
    double targetPercent = _target * 100;
    String mensaje;
    if (nuevoIGC <= targetPercent) {
      mensaje = AppLocalizations.of(context)!.targetReachedMessage;
    } else {
      double cambio = previous - nuevoIGC;
      if (nuevoIGC < previous) {
        mensaje = AppLocalizations.of(context)!
            .congratulationsMessage(cambio.abs().toStringAsFixed(2));
      } else if (nuevoIGC > previous) {
        mensaje = AppLocalizations.of(context)!
            .attentionMessage(cambio.abs().toStringAsFixed(2));
      } else {
        mensaje = AppLocalizations.of(context)!
            .keepWorkingMessage(nuevoIGC.toStringAsFixed(2));
      }
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.progressUpdatedTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(
                  color: Colors.white70,
                  thickness: 1.5,
                  height: 20,
                ),
                Text(
                  mensaje,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.daysRemaining(diasTotales),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(244, 67, 54, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/progreso');
                  },
                  child: Text(
                    AppLocalizations.of(context)!.close,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSimulatedAppBar(String title) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _getSelectedScreen() {
    if (_selectedIndex == 0) {
      Map<String, double> dataMap = {
        AppLocalizations.of(context)!.leanMassLabel: masaMagra,
        AppLocalizations.of(context)!.fatMassLabel: masaGrasa,
      };
      return SafeArea(
        child: Container(
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: buildSimulatedAppBar(
                      AppLocalizations.of(context)!.progressTitle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -35),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PieChart(
                          dataMap: dataMap,
                          animationDuration:
                              const Duration(milliseconds: 800),
                          chartRadius: 180,
                          colorList: const [Colors.green, Colors.red],
                          chartType: ChartType.disc,
                          ringStrokeWidth: 32,
                          legendOptions: const LegendOptions(
                            showLegends: false,
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: false,
                            showChartValues: true,
                            chartValueStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decimalPlaces: 2,
                            chartValueBackgroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.leanMassText(
                                  masaMagra.toStringAsFixed(1)),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.fatMassText(
                                  masaGrasa.toStringAsFixed(1)),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildProgreso(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final result =
                                      await Navigator.push<double>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        gender: widget.gender,
                                        deficit: userDeficit,
                                      ),
                                    ),
                                  );
                                  if (result != null) {
                                    Future.delayed(
                                        const Duration(seconds: 1), () {
                                      _mostrarFelicitationDialog(
                                        result,
                                        diasTotales,
                                        previous:
                                            _lastGrasaCorporal ??
                                                _grasaCorporalInicial,
                                      );
                                      _lastGrasaCorporal = result;
                                    });
                                  }
                                  await _getUserData();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(
                                      244, 67, 54, 1),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .reviewButtonText,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _interstitialAdManager.showAd(context);
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultScreen(
                                          gender: widget.gender,
                                          deficit: userDeficit,
                                          igc: _grasaCorporal,
                                          masaMagra: masaMagra,
                                          masaGrasa: masaGrasa,
                                          pesoEliminar:
                                              pesoEliminar, 
                                          caloriasTotales:
                                              caloriasTotales, 
                                          diasTotales:
                                              double.tryParse(diasTotales) ??
                                                  0.0,
                                          target: _target,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .reportButtonText,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0),
                          margin: const EdgeInsets.all(10.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .reviewDescription,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
} else if (_selectedIndex == 1) {
  return SafeArea(
    child: Container(
      color: Colors.black,
      child: Transform.translate(
        offset: const Offset(0, 13.5),
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(0, -12.5),
              child: buildSimulatedAppBar(AppLocalizations.of(context)!.routineTitle),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Opacity(
                  opacity: 1.0,
                  child: Image.asset(
                    'assets/fit_league1.png',
                    height: 150,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Transform.translate(
                offset: const Offset(0, -60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.fitness_center,
                                    color: Colors.red,
                                    size: 26,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!.gymTitle,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              for (int i = 1; i <= 5; i++)
                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.75,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await _showTrainingInterstitialIfNeeded();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EjerciciosScreen(day: i, isGym: true),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${AppLocalizations.of(context)!.day} $i",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            AnimatedArrow(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.75,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showConsejosDialog(context);
                                    },
                                    child: Card(
                                      color: Colors.yellow,
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.consejos,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.red,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.noGymTitle,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.home,
                                    color: Colors.red,
                                    size: 26,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              for (int i = 1; i <= 5; i++)
                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.75,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await _showTrainingInterstitialIfNeeded();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EjerciciosScreen(day: i, isGym: false),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${AppLocalizations.of(context)!.day} $i",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            AnimatedArrow(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.75,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showNoGymConsejosDialog(context);
                                    },
                                    child: Card(
                                      color: Colors.yellow,
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.consejos,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
} else if (_selectedIndex == 2) {
  final double baseCalories = (userGender.toLowerCase() == 'hombre' ||
          userGender.toLowerCase() == 'male')
      ? 2800.0
      : 2200.0;
  final double totalCalories = baseCalories - userDeficit;
  if (!_menuAdjustedManually) {
    menu = _getMenu(totalCalories);
  }
  return SafeArea(
    child: Stack(
      children: [
        Container(
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, 1),
                  child: buildSimulatedAppBar(
                    AppLocalizations.of(context)!.dietTitle,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 19),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.chooseWhatYouEat_question,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 228, 228, 228),
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.chooseWhatYouEat_answer,
                            style: const TextStyle(
                              color: Color.fromRGBO(255, 82, 82, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 21),
                  child: Center(
                    child: Lottie.asset(
                      'assets/animations/food-vlogger.json',
                      width: 170,
                      height: 170,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.dailyCalories_label,
                                style: const TextStyle(color: Color.fromARGB(255, 228, 228, 228)),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .dailyCalories_value(totalCalories.toStringAsFixed(0)),
                                style: const TextStyle(color: Color.fromRGBO(255, 82, 82, 1)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1),
                        _buildCustomMealCard(context, "desayuno", menu['desayunoCalories']),
                        _buildCustomMealCard(context, "almuerzo", menu['almuerzoCalories']),
                        _buildCustomMealCard(context, "merienda", menu['meriendaCalories']),
                        _buildCustomMealCard(context, "cena", menu['cenaCalories']),
                        const SizedBox(height: 8),
                        Transform.translate(
                          offset: const Offset(0, -5),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)!.infoChangeDeficit,
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 8,
          child: Transform.translate(
            offset: const Offset(-6.5, 200), 
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RecipeLibraryScreen()),
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.menu_book,
                    color: Color.fromARGB(255, 224, 195, 132),
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 8,
          child: Transform.translate(
            offset: const Offset(0, 240),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          AppLocalizations.of(context)!.selectOptionTitle,
                          style: const TextStyle(color: Colors.black),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(color: Colors.red),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.change_circle, color: Colors.red),
                                title: Text(
                                  AppLocalizations.of(context)!.changeDeficitText,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: Text(
                                          AppLocalizations.of(context)!.changeDeficitQuestion,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!.noButton,
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              _interstitialAdManager.showAd(context);
                                              final newDeficit = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => DeficitSelectionScreen(gender: widget.gender),
                                                ),
                                              );
                                              if (newDeficit != null && newDeficit is double) {
                                                setState(() {
                                                  userDeficit = newDeficit;
                                                  _menuAdjustedManually = false;
                                                });
                                                final user = FirebaseAuth.instance.currentUser;
                                                if (user != null) {
                                                  await FirebaseFirestore.instance
                                                      .collection('usuarios')
                                                      .doc(user.uid)
                                                      .update({
                                                    'menuAdjustedManually': false,
                                                    'manualDeficit': FieldValue.delete(),
                                                    'deficit': newDeficit,
                                                  });
                                                }
                                                final double baseCalories = (userGender.toLowerCase() == 'hombre' ||
                                                        userGender.toLowerCase() == 'male')
                                                    ? 2800.0
                                                    : 2200.0;
                                                final double totalCalories = baseCalories - userDeficit;
                                                setState(() {
                                                  menu = _getMenu(totalCalories);
                                                });
                                              }
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!.yesButton,
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.tune, color: Colors.red),
                                title: Text(
                                  AppLocalizations.of(context)!.adjustMealCaloriesText,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MealCaloriesAdjustmentScreen(
                                        gender: widget.gender,
                                        deficit: userDeficit,
                                      ),
                                    ),
                                  );
                                  if (result != null && result is Map<String, dynamic>) {
                                    setState(() {
                                      menu = result;
                                      _menuAdjustedManually = true;
                                    });
                                    final user = FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      await FirebaseFirestore.instance
                                          .collection('usuarios')
                                          .doc(user.uid)
                                          .update({'menuAdjustedManually': true});
                                    }
                                  }
                                },
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.info_outline, color: Colors.red),
                                title: Text(
                                  AppLocalizations.of(context)!.nutritionalEducationText,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NutritionalEducationScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 163, 163, 163),
                    size: 45,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
} else {
  return Container();
}
  }

String localizedMealLabel(BuildContext context, String fixedMealType) {
  switch (fixedMealType.toLowerCase()) {
    case "desayuno":
      return AppLocalizations.of(context)!.breakfastMeal;
    case "almuerzo":
      return AppLocalizations.of(context)!.lunchMeal;
    case "merienda":
      return AppLocalizations.of(context)!.snackMeal;
    case "cena":
      return AppLocalizations.of(context)!.dinnerMeal;
    default:
      return fixedMealType;
  }
}

Widget _buildCustomMealCard(BuildContext context, String fixedMealType, int mealCalories) {
  return Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      leading: Icon(_getMealIcon(fixedMealType), color: const Color.fromRGBO(255, 82, 82, 1), size: 28),
      title: Text(
        AppLocalizations.of(context)!.createMealCardTitle(_capitalize(localizedMealLabel(context, fixedMealType))),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        AppLocalizations.of(context)!.caloriesAssigned(mealCalories.toString()),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.redAccent),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomMealScreen(
              mealType: fixedMealType,
              mealCalories: mealCalories,
            ),
          ),
        );
      },
    ),
  );
}

IconData _getMealIcon(String mealType) {
  switch (mealType.toLowerCase()) {
    case 'desayuno':
      return Icons.free_breakfast;
    case 'almuerzo':
      return Icons.lunch_dining;
    case 'merienda':
      return Icons.local_cafe;
    case 'cena':
      return Icons.dinner_dining;
    default:
      return Icons.fastfood;
  }
}

String _capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

Map<String, dynamic> _getMenu(double totalCalories) {
  return {
    'desayunoCalories': (totalCalories * 0.20).round(),
    'almuerzoCalories': (totalCalories * 0.30).round(),
    'meriendaCalories': (totalCalories * 0.20).round(),
    'cenaCalories': (totalCalories * 0.30).round(),
  };
}
  
  String _adjustGrams(String item, int baseGrams, int caloriesPer100g, double factor) {
    final adjustedGrams = (baseGrams * factor).round();
    final adjustedCalories = (adjustedGrams * caloriesPer100g / 100).round();
    return "$item: ${adjustedGrams}g ($adjustedCalories calorías)";
  }

  Widget _buildResultRow(BuildContext context, IconData icon, String label, String value) {
    double totalWidth = MediaQuery.of(context).size.width * 0.95;
    double iconContainerWidth = 50.0;
    double textMaxWidth = totalWidth - iconContainerWidth - 16.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: iconContainerWidth,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 40,
              color: const Color.fromRGBO(244, 67, 54, 1),
            ),
          ),
          const SizedBox(width: 16),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: textMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(255, 241, 241, 1),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgreso() {
    if (_grasaCorporalInicial == 0.0 || pesoInicial == 0.0) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noProgressData,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    final double targetPercent = _target * 100;
    const double tolerancia = 0.2;

    final double denom = (_grasaCorporalInicial - targetPercent).abs();
    double progreso = denom == 0
        ? 1.0
        : (_grasaCorporalInicial - _grasaCorporal) / denom;
    progreso = progreso.clamp(0.0, 1.0);

    final double pesoActual = masaMagra + masaGrasa;
    final double pesoFinalFijo = _pesoFinalObjetivo; 

    if (_grasaCorporal <= targetPercent + tolerancia || pesoActual <= pesoFinalFijo) {
      progreso = 1.0;
    }

    final bool yaAlcanzado = progreso >= 1.0;
    final String displayedPesoFinal = yaAlcanzado
        ? AppLocalizations.of(context)!.alcanzado
        : pesoFinalFijo.toStringAsFixed(2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.currentFatIndex(_grasaCorporal.toStringAsFixed(1)),
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_grasaCorporal.toStringAsFixed(1)}%",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Container(
              width: MediaQuery.of(context).size.width * 0.50,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: progreso,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "${(progreso * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "$targetPercent%",
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 5),

        if (yaAlcanzado)
          Text(
            AppLocalizations.of(context)!.alcanzado,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        else
          Text(
            AppLocalizations.of(context)!.finalWeightLabel(displayedPesoFinal),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

        const SizedBox(height: 5),
        Text(
          AppLocalizations.of(context)!.daysRemaining(diasTotales),
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 245, 245),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

    
  Widget _buildNavIcon(String iconPath, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 32,
            height: 32,
            color: isSelected ? Color.fromARGB(255, 184, 13, 13) : Colors.black,
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitWave(
                  color: Color.fromARGB(255, 244, 67, 54),
                  size: 50.0,
                ),
                SizedBox(height: 20),
              ],
            )
          : SingleChildScrollView(
              child: _getSelectedScreen(),
            ),
    ),
    bottomNavigationBar: isLoading
        ? null
        : BottomAppBar(
            color: Colors.transparent,
            elevation: 10,
            child: ClipRRect(
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  height: 110,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 245, 245),
                  ),
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavIcon('icons/progreso.png', 0),
                        _buildNavIcon('icons/exercise.png', 1),
                        _buildNavIcon('icons/diet.png', 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
  );
}
}

class AnimatedArrow extends StatefulWidget {
  const AnimatedArrow({super.key});

  @override
  AnimatedArrowState createState() => AnimatedArrowState();
}

class AnimatedArrowState extends State<AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.2, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.red,
      ),
    );
  }
}

class EjerciciosScreen extends StatefulWidget {
  final int day;
  final bool isGym;

  const EjerciciosScreen({
    super.key,
    required this.day,
    required this.isGym,
  });

  @override
  EjerciciosScreenState createState() => EjerciciosScreenState();
}

class EjerciciosScreenState extends State<EjerciciosScreen> {
  @override
  Widget build(BuildContext context) {
    final routineText = RoutineModule.getRoutine(
      context: context,
      day: widget.day,
      isGym: widget.isGym,
    );
    final parts = routineText.split("\n\n");
    final headerText = parts.isNotEmpty ? parts[0] : "";
    final warmupText = parts.length > 1 ? parts[1] : "";
    final exercisesBlock = parts.length > 2 ? parts[2] : "";
    final cooldownText = parts.length > 3 ? parts[3] : "";

    List<String> exerciseLinesRaw;
    if (exercisesBlock.startsWith("Ejercicios:") ||
        exercisesBlock.startsWith("Exercises:")) {
      exerciseLinesRaw = exercisesBlock
          .substring(exercisesBlock.indexOf(':') + 1)
          .trim()
          .split("\n");
    } else {
      exerciseLinesRaw = exercisesBlock.split("\n");
    }
    final exerciseLines = exerciseLinesRaw
        .where((line) => RegExp(r'^\d+\.').hasMatch(line.trim()))
        .toList();

    final locale = Localizations.localeOf(context).languageCode;
    final dayPrefix = locale == 'es' ? "DIA" : "DAY";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "$dayPrefix ${widget.day}",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                headerText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                warmupText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  for (var i = 0; i < exerciseLines.length; i++) ...[
                    Builder(builder: (_) {
                      final rawLine = exerciseLines[i];
                      final withoutNumber = rawLine.trim().replaceFirst(
                        RegExp(r'^\d+\.\s*'),
                        '',
                      );
                      final key = withoutNumber.split(':').first.trim();
                      final hasVideo = exerciseVideoMap.containsKey(key);
                      final videoUrl = hasVideo
                          ? exerciseVideoMap[key]!
                          : '';
                      return ExerciseItem(
                        name: withoutNumber,
                        videoUrl: videoUrl,
                        showControls: hasVideo,
                      );
                    }),
                    if (i < exerciseLines.length - 1)
                      Divider(
                        color: Colors.grey.shade800,
                        thickness: 1,
                      ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              Text(
                cooldownText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoutineModule {
  static String getRoutine({
    required BuildContext context,
    required int day,
    required bool isGym,
  }) {
    final loc = AppLocalizations.of(context)!;
    if (isGym) {
      switch (day) {
        case 1:
          return loc.gymRoutineDay1;
        case 2:
          return loc.gymRoutineDay2;
        case 3:
          return loc.gymRoutineDay3;
        case 4:
          return loc.gymRoutineDay4;
        case 5:
          return loc.gymRoutineDay5;
      }
    } else {
      switch (day) {
        case 1:
          return loc.noGymRoutineDay1;
        case 2:
          return loc.noGymRoutineDay2;
        case 3:
          return loc.noGymRoutineDay3;
        case 4:
          return loc.noGymRoutineDay4;
        case 5:
          return loc.noGymRoutineDay5;
      }
    }
    return "--- Rutina no definida para ${isGym ? 'Gym' : 'Casa'} ---";
  }
}

void _showConsejosDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.black,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.gymTips1,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.gymTips2,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.gymTips3,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.gymTips4,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.gymTips5,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.gymTips6,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 8),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.close,
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showNoGymConsejosDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.black,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.noGymTips1,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips2,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips3,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips4,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips5,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips6,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips7,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips8,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips9,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noGymTips12,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 8),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.close,
                      style: const TextStyle(color: Colors.yellow, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}