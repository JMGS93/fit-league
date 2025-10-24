import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Baseline {
  static Future<void> ensure({
    required double masaMagra,
    required double masaGrasa,
    required double igc,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
    final snap = await doc.get();

    if (snap.exists &&
        snap.data()?['pesoInicial']           != null &&
        snap.data()?['masaMagraInicial']      != null &&
        snap.data()?['grasaCorporalInicial']  != null) {
      return;
    }

    await doc.set({
      'pesoInicial'          : masaMagra + masaGrasa,
      'masaMagraInicial'     : masaMagra,
      'grasaCorporalInicial' : igc,
    }, SetOptions(merge: true));
  }
}