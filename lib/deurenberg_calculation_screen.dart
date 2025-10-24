import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'result_screen.dart';
import 'widgets/banner_ad_widget.dart';
import 'widgets/interstitial_ad_manager.dart';
import 'dart:developer' as developer;
import 'gender_selection_screen.dart';
import 'utils/baseline.dart' as bl;

Route<T> noAnimationRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

class DeurenbergCalculationScreen extends StatefulWidget {
  final Gender gender;
  final double deficit;
  final double target; 

  const DeurenbergCalculationScreen({
    super.key,
    required this.gender,
    required this.deficit,
    this.target = 0.15,
  });

  @override
  DeurenbergCalculationScreenState createState() =>
      DeurenbergCalculationScreenState();
}

class DeurenbergCalculationScreenState
    extends State<DeurenbergCalculationScreen> {
  final TextEditingController _edadController   = TextEditingController();
  final TextEditingController _pesoController   = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  bool _isLoading = false;

  late double _target;

  late InterstitialAdManager _interstitialAdManager;

  @override
  void initState() {
    super.initState();
    _target = widget.target;
    _guardarPantallaActual();
    _interstitialAdManager = InterstitialAdManager()..loadAd();
  }

  Future<void> _guardarPantallaActual() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'deurenbergCalculationScreen');
  }

  void _calcularIGCDeurenberg() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    final edad     = double.tryParse(_edadController.text)   ?? 0;
    final peso     = double.tryParse(_pesoController.text)   ?? 0;
    final alturaCm = double.tryParse(_alturaController.text) ?? 0;

    if (edad <= 0 || peso <= 0 || alturaCm <= 0) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final docRefPrev = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid);
    final snapPrev = await docRefPrev.get();

    double? storedTarget;
    double? storedIgcAlcanzada;      
    double? storedPesoFinalAlcanzado; 
    bool prevGoalReached = false;

    if (snapPrev.exists) {
      final dataPrev = snapPrev.data()!;
      if (dataPrev['lastTarget'] != null) {
        storedTarget = double.tryParse(dataPrev['lastTarget'].toString());
      }
      if (dataPrev['grasaCorporalAlcanzada'] != null) {
        storedIgcAlcanzada =
            double.tryParse(dataPrev['grasaCorporalAlcanzada'].toString());
      }
      if (dataPrev['pesoFinalAlcanzado'] != null) {
        storedPesoFinalAlcanzado =
            double.tryParse(dataPrev['pesoFinalAlcanzado'].toString());
      }
      if (dataPrev['objetivoAlcanzado'] != null) {
        prevGoalReached = dataPrev['objetivoAlcanzado'] as bool;
      }
    }

    final bool cambioTarget =
        (storedTarget != null && storedTarget != _target);

    double igcReal;
    if (cambioTarget
        && prevGoalReached
        && storedIgcAlcanzada != null
        && storedPesoFinalAlcanzado != null
        && peso <= storedPesoFinalAlcanzado) {
      igcReal = storedIgcAlcanzada;
    } else {
      final alturaM = alturaCm / 100;
      final imc     = peso / (alturaM * alturaM);
      final int sexo = widget.gender == Gender.male ? 1 : 0;
      igcReal = (1.20 * imc) + (0.23 * edad) - (10.8 * sexo) - 5.4;
    }

    final double allowedDeficit =
        widget.gender == Gender.female ? 500.0 : 700.0;
    final double deficitCalorico =
        widget.deficit < allowedDeficit ? widget.deficit : allowedDeficit;
    const double caloriasEjercicio = 350.0;
    final double deficitTotal = deficitCalorico + caloriasEjercicio;
    const double caloriasPorKg = 7700.0;

    final double pesoGrasaActualReal = peso * igcReal / 100;
    double masaMagra = peso - pesoGrasaActualReal;
    double masaGrasa = pesoGrasaActualReal;

    double pesoInicial      = peso;
    double masaMagraInicial = masaMagra;
    if (snapPrev.exists &&
        snapPrev.data()?['pesoInicial'] != null &&
        snapPrev.data()?['masaMagraInicial'] != null) {
      pesoInicial = double.tryParse(
            snapPrev.data()!['pesoInicial'].toString()) ??
          (masaMagra + masaGrasa);
      masaMagraInicial = double.tryParse(
            snapPrev.data()!['masaMagraInicial'].toString()) ??
          masaMagra;
    }

    if (cambioTarget) {
      await docRefPrev.set({
        'pesoInicial':       peso,
        'masaMagraInicial':  masaMagra,
      }, SetOptions(merge: true));

      pesoInicial = peso;
      masaMagraInicial = masaMagra;
    }

    final double Wfinal = masaMagraInicial / (1.0 - _target);
    final double pesoActual = peso;

    const double tolerancia = 0.2;
    final double targetPercent = _target * 100;
    final bool objetivoCumplido = (igcReal <= targetPercent + tolerancia) ||
        (pesoActual <= Wfinal);

    double caloriasTotalesFinal;
    double diasTotalesFinal;
    double pesoGrasaPerderFinal;
    double pesoMeta = Wfinal; 

    if (objetivoCumplido) {
      igcReal = targetPercent;
      masaGrasa = pesoMeta * _target;
      masaMagra = pesoMeta - masaGrasa;

      caloriasTotalesFinal = 0;
      diasTotalesFinal     = 0;
      pesoGrasaPerderFinal = 0;
    } else {
      final double masaGrasaObjetivoEnKg = Wfinal * _target;
      final double kilosGrasaRestantes =
          (pesoGrasaActualReal - masaGrasaObjetivoEnKg)
              .clamp(0, double.infinity);
      caloriasTotalesFinal = kilosGrasaRestantes * caloriasPorKg;
      diasTotalesFinal =
          (caloriasTotalesFinal / deficitTotal).ceilToDouble();
      pesoGrasaPerderFinal = kilosGrasaRestantes;
    }

    await bl.Baseline.ensure(
      masaMagra: masaMagra,
      masaGrasa: masaGrasa,
      igc:       igcReal,
    );

    try {
      bool debeRecalcularPesoFinal = false;
      if (!snapPrev.exists ||
          snapPrev.data()?['pesoFinalObjetivo'] == null) {
        debeRecalcularPesoFinal = true;
      } else if (storedTarget != null && storedTarget != _target) {
        debeRecalcularPesoFinal = true;
      }

      if (debeRecalcularPesoFinal) {
        final double WfinalRecalc =
            masaMagraInicial / (1.0 - _target);
        await docRefPrev.set({
          'pesoFinalObjetivo': WfinalRecalc,
        }, SetOptions(merge: true));
      }

      if (objetivoCumplido && storedIgcAlcanzada == null) {
        await docRefPrev.set({
          'grasaCorporalAlcanzada': igcReal,
          'pesoFinalAlcanzado':      pesoMeta,
        }, SetOptions(merge: true));
      }

      await docRefPrev.set({
        'pesoFinalObjetivo': debeRecalcularPesoFinal
            ? masaMagraInicial / (1.0 - _target)
            : snapPrev.data()?['pesoFinalObjetivo'],
        'email':            user.email,
        'result':           localizations
            .resultText(igcReal.toStringAsFixed(2)),
        'diasTotales':      diasTotalesFinal.toString(),
        'masaMagra':        masaMagra,
        'masaGrasa':        masaGrasa,
        'grasaCorporal':    igcReal,
        'pesoEliminar':     pesoGrasaPerderFinal,
        'caloriasTotales':  caloriasTotalesFinal,
        'lastTarget':       _target,
        'objetivoAlcanzado': objetivoCumplido,
      }, SetOptions(merge: true));
    } catch (e, s) {
      developer.log('Error saving result: $e', stackTrace: s);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'resultScreen');
    _interstitialAdManager.showAd(context);

    final result = await Navigator.push<double>(
      context,
      noAnimationRoute(
        ResultScreen(
          gender:          widget.gender,
          deficit:         widget.deficit,
          igc:             igcReal,
          masaMagra:       masaMagra,
          masaGrasa:       masaGrasa,
          pesoEliminar:    pesoGrasaPerderFinal,
          caloriasTotales: caloriasTotalesFinal,
          diasTotales:     diasTotalesFinal,
          target:          _target,
        ),
      ),
    );
    Navigator.pop(context, result ?? igcReal);

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildLabeledInput(
    int index,
    String title,
    TextEditingController controller,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$index. $title',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(
                  color: Color.fromARGB(255, 244, 67, 54), width: 2),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.alternativeCalculationTitle,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.percent, color: Colors.white),
            tooltip: _target == 0.10
                ? localizations.changeTargetTo15
                : _target == 0.15
                    ? localizations.changeTargetTo20
                    : localizations.changeTargetTo10,
            onPressed: () async {
              setState(() {
                if (_target == 0.10) {
                  _target = 0.15;
                } else if (_target == 0.15) {
                  _target = 0.20;
                } else {
                  _target = 0.10;
                }
              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.setDouble("target", _target);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              child: BannerAdWidget(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        localizations.objectiveText(
                            (_target * 100).toStringAsFixed(0)),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 244, 67, 54),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        localizations.alternativeCalculationDescription,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      _buildLabeledInput(
                          1,
                          localizations.ageTitle,
                          _edadController,
                          localizations.ageLabel),
                      _buildLabeledInput(
                          2,
                          localizations.heightTitle,
                          _alturaController,
                          localizations.heightLabel),
                      _buildLabeledInput(
                          3,
                          localizations.weightTitle,
                          _pesoController,
                          localizations.weightLabel),
                      const SizedBox(height: 10),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _calcularIGCDeurenberg,
                            child: Text(localizations.calculateButton),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 244, 67, 54),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              child: BannerAdWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
