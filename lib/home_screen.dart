import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'result_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deurenberg_calculation_screen.dart';
import 'main.dart';
import 'widgets/interstitial_ad_manager.dart';
import 'widgets/banner_ad_widget.dart';
import 'dart:developer' as developer;
import 'gender_selection_screen.dart';
import 'utils/baseline.dart' as bl;

Route<dynamic> noAnimationRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

class HomeScreen extends StatefulWidget {
  final Gender gender;
  final double deficit;
  final double target; 

  const HomeScreen({
    super.key,
    required this.gender,
    required this.deficit,
    this.target = 0.15,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with RouteAware {
  late double _target;
  final TextEditingController _cinturaController = TextEditingController();
  final TextEditingController _cuelloController   = TextEditingController();
  final TextEditingController _alturaController   = TextEditingController();
  final TextEditingController _caderaController   = TextEditingController();
  final TextEditingController _pesoController     = TextEditingController();

  String  _resultado    = '';
  String  _diasTotales  = '';
  bool    _isLoading    = false;
  late InterstitialAdManager _interstitialAdManager;

  @override
  void initState() {
    super.initState();
    _guardarPantallaActual();
    _target = widget.target;
    _loadTarget();
    _isLoading = false;
    _interstitialAdManager = InterstitialAdManager();
    _interstitialAdManager.loadAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showIGCInfoDialog();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _interstitialAdManager.dispose();
    super.dispose();
  }

  void _guardarPantallaActual() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'homeScreen');
  }

  Future<void> _loadTarget() async {
    final prefs = await SharedPreferences.getInstance();
    double? savedTarget = prefs.getDouble("target");
    if (savedTarget != null && mounted) {
      setState(() {
        _target = savedTarget;
      });
    }
  }

  void _calcularIGC() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    final cintura = double.tryParse(_cinturaController.text) ?? 0;
    final cuello  = double.tryParse(_cuelloController.text)   ?? 0;
    final altura  = double.tryParse(_alturaController.text)   ?? 0;
    final cadera  = double.tryParse(_caderaController.text)   ?? 0;
    final peso    = double.tryParse(_pesoController.text)     ?? 0;

    if (cintura <= 0 || cuello <= 0 || altura <= 0 || peso <= 0) {
      setState(() {
        _resultado   = localizations.errorAllDataRequired;
        _diasTotales = '';
        _isLoading   = false;
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _resultado   = localizations.errorAllDataRequired;
        _diasTotales = '';
        _isLoading   = false;
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
      if (widget.gender == Gender.female) {
        if (cadera > 0) {
          igcReal = 163.205 * (log(cintura + cadera - cuello) / log(10))
                    - 97.684 * (log(altura) / log(10))
                    - 78.387;
        } else {
          setState(() {
            _resultado   = localizations.errorHipRequired;
            _diasTotales = '';
            _isLoading   = false;
          });
          return;
        }
      } else {
        igcReal = 86.010 * (log(cintura - cuello) / log(10))
                 - 70.041 * (log(altura) / log(10))
                 + 36.76;
      }
    }

    final double allowedDeficit = widget.gender == Gender.female ? 500.0 : 700.0;
    final double deficitCalorico = min(widget.deficit, allowedDeficit);
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

    if (cambioTarget || (peso < pesoInicial)) {
      await docRefPrev.set({
        'pesoInicial':       peso,
        'masaMagraInicial':  masaMagra,
      }, SetOptions(merge: true));

      pesoInicial = peso;
      masaMagraInicial = masaMagra;
    }

    final double Wfinal = masaMagraInicial / (1.0 - _target);
    final double pesoActual = masaMagra + masaGrasa;

    const double tolerancia = 0.2;
    final double targetPercent = _target * 100;
    final bool objetivoCumplido =
        (igcReal <= targetPercent + tolerancia) || (pesoActual <= Wfinal);

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
          (pesoGrasaActualReal - masaGrasaObjetivoEnKg).clamp(0, double.infinity);
      caloriasTotalesFinal = kilosGrasaRestantes * caloriasPorKg;
      diasTotalesFinal = (caloriasTotalesFinal / deficitTotal).ceilToDouble();
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
        final double WfinalRecalc = masaMagraInicial / (1.0 - _target);
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
        'email':            user.email,
        'result':           localizations.resultText(igcReal.toStringAsFixed(2)),
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
      developer.log('Error saving result in Firestore: $e', stackTrace: s);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'resultScreen');
    _interstitialAdManager.showAd(context);

    final result = await Navigator.push<dynamic>(
      context,
      noAnimationRoute(
        ResultScreen(
          gender:           widget.gender,
          deficit:          widget.deficit,
          igc:              igcReal,
          masaMagra:        masaMagra,
          masaGrasa:        masaGrasa,
          pesoEliminar:     pesoGrasaPerderFinal,
          caloriasTotales:  caloriasTotalesFinal,
          diasTotales:      diasTotalesFinal,
          target:           _target,
        ),
      ),
    );
    Navigator.pop(context, result ?? igcReal);

    setState(() {
      _isLoading = false;
    });
  }

  void _showIGCInfoDialog() async {
    final prefs = await SharedPreferences.getInstance();
    bool hideIGCInfo = prefs.getBool('hideIGCInfo') ?? false;
    if (hideIGCInfo) return;

    bool dontShowAgain = false;
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.igcInfoTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 244, 67, 54),
                        thickness: 2,
                        height: 20,
                      ),
                      Text(
                        localizations.igcInfoMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: dontShowAgain,
                            onChanged: (value) {
                              setState(() {
                                dontShowAgain = value ?? false;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 244, 67, 54),
                            checkColor: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              localizations.igcInfoDontShowAgain,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (dontShowAgain) {
                            await prefs.setBool('hideIGCInfo', true);
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 244, 67, 54),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          localizations.okButton,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarImagen(BuildContext context, String nombreImagen) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Image.asset('assets/$nombreImagen'),
          actions: [
            TextButton(
              child: Text(
                localizations.close,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabeledInput(
    int index,
    String title,
    TextEditingController controller,
    String label,
  ) {
    final localizations = AppLocalizations.of(context)!;
    String? imageName;
    if (title == localizations.cinturaTitle) {
      imageName = widget.gender == Gender.female
          ? 'cintura_mujeres.jpg'
          : 'cintura_hombres.jpg';
    } else if (title == localizations.cuelloTitle) {
      imageName = 'cuello_hombres.jpg';
    } else if (title == localizations.caderaTitle && widget.gender == Gender.female) {
      imageName = 'cadera_mujeres.jpg';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                '$index. $title',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (imageName != null)
              TextButton(
                onPressed: () => _mostrarImagen(context, imageName!),
                child: Text(
                  localizations.viewExample,
                  style: const TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
        _buildInputCard(controller, label),
      ],
    );
  }

  Widget _buildInputCard(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: Color.fromARGB(255, 244, 67, 54), width: 2),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          localizations.enterYourData,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.black,
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
      body: Container(
        color: Colors.black,
        child: Transform.translate(
          offset: const Offset(0, -70),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60, child: BannerAdWidget()),
                  const SizedBox(height: 20),
                  Text(
                    localizations.objectiveText((_target * 100).toStringAsFixed(0)),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 244, 67, 54),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabeledInput(
                    1,
                    localizations.cinturaTitle,
                    _cinturaController,
                    localizations.cinturaLabel,
                  ),
                  _buildLabeledInput(
                    2,
                    localizations.cuelloTitle,
                    _cuelloController,
                    localizations.cuelloLabel,
                  ),
                  _buildLabeledInput(
                    3,
                    localizations.alturaTitle,
                    _alturaController,
                    localizations.alturaLabel,
                  ),
                  if (widget.gender == Gender.female)
                    _buildLabeledInput(
                      4,
                      localizations.caderaTitle,
                      _caderaController,
                      localizations.caderaLabel,
                    ),
                  _buildLabeledInput(
                    5,
                    localizations.pesoTitle,
                    _pesoController,
                    localizations.pesoLabel,
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color.fromARGB(255, 241, 67, 54),
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _calcularIGC,
                              child: Text(localizations.calculateButton),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 67, 54),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString(
                                          'lastScreen',
                                          'deurenbergCalculationScreen');
                                      Navigator.push(
                                        context,
                                        noAnimationRoute(
                                          DeurenbergCalculationScreen(
                                            gender: widget.gender,
                                            deficit: widget.deficit,
                                            target: _target,
                                          ),
                                        ),
                                      );
                                    },
                              child: Text(localizations.alternativeCalculationButton),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

