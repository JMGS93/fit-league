import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> saveUserData(User user, Map<String, dynamic> data) async {
    await _db.collection('users').doc(user.uid).set(data);
  }
  Future<Map<String, dynamic>> loadUserData(User user) async {
    DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
    return doc.data() as Map<String, dynamic>;
  }
}