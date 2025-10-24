import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient.dart';

class CustomMeal {
  final String id;
  final String name;
  final Ingredient main;
  final int mainGrams;
  final Ingredient? side1;
  final int? side1Grams;
  final Ingredient? side2;
  final int? side2Grams;
  final Ingredient? side3;
  final int? side3Grams;

  CustomMeal({
    required this.id,
    required this.name,
    required this.main,
    required this.mainGrams,
    this.side1,
    this.side1Grams,
    this.side2,
    this.side2Grams,
    this.side3,
    this.side3Grams,
  });

  double get totalCalories {
    double total = mainGrams * main.caloriesPer100g / 100;
    if (side1 != null && side1Grams != null) {
      total += side1Grams! * side1!.caloriesPer100g / 100;
    }
    if (side2 != null && side2Grams != null) {
      total += side2Grams! * side2!.caloriesPer100g / 100;
    }
    if (side3 != null && side3Grams != null) {
      total += side3Grams! * side3!.caloriesPer100g / 100;
    }
    return total;
  }

  double get totalProtein {
    double total = mainGrams * main.proteinPer100g / 100;
    if (side1 != null && side1Grams != null) {
      total += side1Grams! * side1!.proteinPer100g / 100;
    }
    if (side2 != null && side2Grams != null) {
      total += side2Grams! * side2!.proteinPer100g / 100;
    }
    if (side3 != null && side3Grams != null) {
      total += side3Grams! * side3!.proteinPer100g / 100;
    }
    return total;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'main': main.toMap(),
      'mainGrams': mainGrams,
      if (side1 != null) 'side1': side1!.toMap(),
      if (side1Grams != null) 'side1Grams': side1Grams,
      if (side2 != null) 'side2': side2!.toMap(),
      if (side2Grams != null) 'side2Grams': side2Grams,
      if (side3 != null) 'side3': side3!.toMap(),
      if (side3Grams != null) 'side3Grams': side3Grams,
    };
  }
  Map<String, dynamic> toMap() => toJson();

  factory CustomMeal.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return CustomMeal(
      id: snap.id,
      name: data['name'] as String,
      main: Ingredient.fromJson(data['main']),
      mainGrams: data['mainGrams'] as int,
      side1: data['side1'] != null ? Ingredient.fromJson(data['side1']) : null,
      side1Grams: data['side1Grams'] as int?,
      side2: data['side2'] != null ? Ingredient.fromJson(data['side2']) : null,
      side2Grams: data['side2Grams'] as int?,
      side3: data['side3'] != null ? Ingredient.fromJson(data['side3']) : null,           
      side3Grams: data['side3Grams'] as int?,                                               
    );
  }
}