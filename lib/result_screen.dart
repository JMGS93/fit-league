import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_screen.dart';
import 'gender_selection_screen.dart';
import 'main_screen.dart';

Route<dynamic> noAnimationRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

class ResultScreen extends StatefulWidget {
  final Gender gender;
  final double deficit;
  final double igc;              
  final double masaMagra;
  final double masaGrasa;
  final double pesoEliminar;    
  final double caloriasTotales;  
  final double diasTotales;      
  final double target;         

  const ResultScreen({
    super.key,
    required this.gender,
    required this.deficit,
    required this.igc,
    required this.masaMagra,
    required this.masaGrasa,
    required this.pesoEliminar,
    required this.caloriasTotales,
    required this.diasTotales,
    required this.target,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveLastScreen();
  }

  Future<void> _saveLastScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'resultScreen');

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .set({'lastScreen': 'resultScreen'}, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final loc = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final targetPct = (widget.target * 100).toStringAsFixed(0);
    final daysLabel = loc.daysUntilPercent(targetPct);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snap.hasData || !snap.data!.exists) {
          final double pesoActualFallback = widget.masaMagra + widget.masaGrasa;
          final double pesoFinalObjFallback =
              widget.masaMagra + (widget.masaMagra + widget.masaGrasa) * widget.target;

          const double tolerancia = 0.2;
          final bool objetivoCumplidoFallback =
              (widget.igc <= widget.target * 100 + tolerancia);

          final double kgGrasaPendFB = objetivoCumplidoFallback ? 0.0 : widget.pesoEliminar;
          final double kcalPendFB   = objetivoCumplidoFallback ? 0.0 : widget.caloriasTotales;
          final double diasPendFB   = objetivoCumplidoFallback ? 0.0 : widget.diasTotales;

          return _buildContent(
            context: context,
            loc: loc,
            screenHeight: screenHeight,
            igcActual: widget.igc,
            masaMagraActual: widget.masaMagra,
            masaGrasaActual: widget.masaGrasa,
            pesoFinalObjetivo: pesoFinalObjFallback,
            kcalPend: kcalPendFB,
            diasPend: diasPendFB,
            objetivoAlcanzado: objetivoCumplidoFallback,
            kgGrasaPend: kgGrasaPendFB,
            targetPct: targetPct,
            daysLabel: daysLabel,
          );
        }

        final data = snap.data!.data() as Map<String, dynamic>;

        double d(dynamic v, double def) =>
            v == null ? def : double.tryParse(v.toString()) ?? def;

        final double pesoInicial      =
            d(data['pesoInicial'], widget.masaMagra + widget.masaGrasa);
        final double masaMagraInicial =
            d(data['masaMagraInicial'], widget.masaMagra);
        final double igcActualStored  = d(data['grasaCorporal'], widget.igc);
        final double masaMagraActual  = d(data['masaMagra'], widget.masaMagra);
        final double masaGrasaActual  = d(data['masaGrasa'], widget.masaGrasa);

        final double igcAlcanzadaStored =
            d(data['grasaCorporalAlcanzada'], igcActualStored);

        final double pesoActual = masaMagraActual + masaGrasaActual;

        final double pesoFinalObjetivoStored = d(
          data['pesoFinalObjetivo'],
          masaMagraInicial + pesoInicial * widget.target,
        );

        final double pesoFinalAlcanzadoStored =
            d(data['pesoFinalAlcanzado'], pesoFinalObjetivoStored);

        final double kgGrasaPendInicial =
            d(data['pesoEliminar'], widget.pesoEliminar);
        final double kcalPendInicial =
            d(data['caloriasTotales'], widget.caloriasTotales);
        final double diasPendInicial =
            d(data['diasTotales'], widget.diasTotales);

        final double storedTarget =
            d(data['lastTarget'], widget.target);

        final bool cambioTarget = (storedTarget != widget.target);

        late double igcActualFinal;
        late double pesoFinalObjetivoFinal;
        late double kgGrasaPendFinal;
        late double kcalPendFinal;
        late double diasPendFinal;
        late bool objetivoAlcanzadoFinal;

        const double tolerancia = 0.2;
        final double targetPercent = widget.target * 100;

        if (cambioTarget) {
          if (pesoActual <= pesoFinalAlcanzadoStored) {
            igcActualFinal = igcAlcanzadaStored;
          } else {
            igcActualFinal = igcActualStored;
          }

          final double WfinalNuevo = masaMagraActual / (1.0 - widget.target);
          pesoFinalObjetivoFinal = WfinalNuevo;

          objetivoAlcanzadoFinal = (igcActualFinal <= targetPercent + tolerancia) ||
                                  (pesoActual <= WfinalNuevo);

          if (objetivoAlcanzadoFinal) {
            kgGrasaPendFinal = 0.0;
            kcalPendFinal   = 0.0;
            diasPendFinal   = 0.0;
          } else {
            final double masaGrasaObjetivoKg = WfinalNuevo * widget.target;
            final double kilosPend = (masaGrasaActual - masaGrasaObjetivoKg)
                .clamp(0.0, double.infinity);
            kgGrasaPendFinal = kilosPend;

            final double caloriasTotalesPend = kilosPend * 7700.0;

            final double allowedDeficit = widget.gender == Gender.female
                ? 500.0
                : 700.0;
            final double deficitCalorico = widget.deficit < allowedDeficit
                ? widget.deficit
                : allowedDeficit;
            const double caloriasEjercicio = 350.0;
            final double deficitTotal = deficitCalorico + caloriasEjercicio;

            kcalPendFinal   = caloriasTotalesPend;
            diasPendFinal   = (caloriasTotalesPend / deficitTotal).ceilToDouble();
          }
        } else {
          igcActualFinal          = igcActualStored;
          pesoFinalObjetivoFinal  = pesoFinalObjetivoStored;
          objetivoAlcanzadoFinal  = (igcActualStored <= targetPercent + tolerancia) ||
                                    (pesoActual <= pesoFinalObjetivoStored);
          kgGrasaPendFinal        = objetivoAlcanzadoFinal ? 0.0 : kgGrasaPendInicial;
          kcalPendFinal           = objetivoAlcanzadoFinal ? 0.0 : kcalPendInicial;
          diasPendFinal           = objetivoAlcanzadoFinal ? 0.0 : diasPendInicial;
        }

        return _buildContent(
          context: context,
          loc: loc,
          screenHeight: screenHeight,
          igcActual: igcActualFinal,
          masaMagraActual: masaMagraActual,
          masaGrasaActual: masaGrasaActual,
          pesoFinalObjetivo: pesoFinalObjetivoFinal,
          kcalPend: kcalPendFinal,
          diasPend: diasPendFinal,
          objetivoAlcanzado: objetivoAlcanzadoFinal,
          kgGrasaPend: kgGrasaPendFinal,
          targetPct: targetPct,
          daysLabel: daysLabel,
        );
      },
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required AppLocalizations loc,
    required double screenHeight,
    required double igcActual,
    required double masaMagraActual,
    required double masaGrasaActual,
    required double pesoFinalObjetivo,
    required double kcalPend,
    required double diasPend,
    required bool objetivoAlcanzado,
    required double kgGrasaPend,
    required String targetPct,
    required String daysLabel,
  }) {
    const double tolerancia = 0.2;
    final double targetPercent = double.parse(targetPct);
    final double pesoActual = masaMagraActual + masaGrasaActual;
    final bool yaAlcanzado =
        (igcActual <= targetPercent + tolerancia) || (pesoActual <= pesoFinalObjetivo);

    final double displayedIGC = yaAlcanzado ? targetPercent : igcActual;

    final String displayedPesoFinal = yaAlcanzado
        ? loc.alcanzado
        : '${pesoFinalObjetivo.toStringAsFixed(2)} kg';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(loc.resultTitle, style: const TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _sectionHeader(loc.tusDatos.toUpperCase()),

                  _row(
                    context,
                    Icons.favorite,
                    loc.resultBodyFatLabel,
                    '${displayedIGC.toStringAsFixed(2)} %',
                  ),
                  _divider(),

                  _row(
                    context,
                    Icons.balance,
                    loc.resultLeanMassLabel,
                    '${masaMagraActual.toStringAsFixed(2)} kg',
                  ),
                  _divider(),

                  _row(
                    context,
                    Icons.balance,
                    loc.resultFatMassLabel,
                    '${masaGrasaActual.toStringAsFixed(2)} kg',
                  ),
                  _divider(),

                  _row(
                    context,
                    Icons.remove_circle_outline,
                    loc.resultWeightToLoseLabel(targetPct),
                    '${kgGrasaPend.toStringAsFixed(2)} kg',
                  ),
                  _divider(),

                  _row(
                    context,
                    Icons.check_circle,
                    loc.resultFinalWeightLabel,
                    displayedPesoFinal,
                  ),
                  _divider(),

                  _row(
                    context,
                    Icons.local_fire_department,
                    loc.resultTotalCaloriesLabel,
                    '${kcalPend.toStringAsFixed(0)} kcal',
                  ),
                  _divider(),

                  _row(
                    context,
                    Icons.timer,
                    daysLabel,
                    diasPend.toStringAsFixed(0),
                  ),

                  const SizedBox(height: 20),
                  _buttons(context, loc),
                  const SizedBox(height: 1),
                  Text(
                    loc.resultInfoText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String t) => Row(
        children: [
          Text(
            t,
            style: const TextStyle(
              color: Color.fromARGB(255, 119, 119, 119),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: _divider()),
        ],
      );

  Widget _divider() => Divider(color: Colors.grey.shade700, thickness: 1);

  Widget _row(BuildContext ctx, IconData icon, String label, String value) {
    final w = MediaQuery.of(ctx).size.width * 0.95;
    const icW = 50.0;
    final maxW = w - icW - 16;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: icW,
            child: Icon(
              icon,
              size: 40,
              color: const Color.fromARGB(255, 244, 67, 54),
            ),
          ),
          const SizedBox(width: 16),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 241, 241, 241),
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

  Widget _buttons(BuildContext ctx, AppLocalizations loc) => Transform.translate(
        offset: const Offset(0, -20),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement<void, void>(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(
                      gender: widget.gender,
                      deficit: widget.deficit,
                      target: widget.target,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  loc.resultChangeTargetButton,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('flowComplete', true);
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    'flowComplete': true,
                    'lastScreen': 'mainScreen'
                  }, SetOptions(merge: true));
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    ctx,
                    noAnimationRoute(MainScreen(
                      gender: widget.gender,
                      deficit: widget.deficit,
                      target: widget.target,
                    )),
                    (_) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  loc.resultHomeButton,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      );
}
