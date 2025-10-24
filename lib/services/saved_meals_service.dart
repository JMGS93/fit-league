import 'package:nuevo_proyecto/models/custom_meal.dart';
import 'package:nuevo_proyecto/services/firestore_saved_meals_service.dart';

class SavedMealsService {
  SavedMealsService._();
  static final instance = SavedMealsService._();

  Stream<List<CustomMeal>> get mealsStream =>
      FirestoreSavedMealsService.instance.mealsStream();

  Future<void> deleteMeal(String id) {
    return FirestoreSavedMealsService.instance.deleteMeal(id);
  }
}