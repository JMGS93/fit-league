import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuevo_proyecto/models/custom_meal.dart';

class FirestoreSavedMealsService {
  FirestoreSavedMealsService._();
  static final instance = FirestoreSavedMealsService._();
  final _db = FirebaseFirestore.instance;

  CollectionReference get _mealsCol {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection('usuarios')
        .doc(uid)
        .collection('savedMeals');
  }

  Stream<List<CustomMeal>> mealsStream() =>
      _mealsCol.snapshots().map(
        (snap) => snap.docs.map((d) => CustomMeal.fromSnapshot(d)).toList(),
      );

  Future<void> addMeal(CustomMeal meal) =>
      _mealsCol.doc(meal.id).set(meal.toJson());

  Future<void> deleteMeal(String id) =>
      _mealsCol.doc(id).delete();
}