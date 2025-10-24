import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nuevo_proyecto/models/custom_meal.dart';
import 'package:nuevo_proyecto/services/saved_meals_service.dart';
import 'subscription_screen.dart';

class RecipeLibraryScreen extends StatefulWidget {
  const RecipeLibraryScreen({Key? key}) : super(key: key);

  @override
  _RecipeLibraryScreenState createState() => _RecipeLibraryScreenState();
}

class _RecipeLibraryScreenState extends State<RecipeLibraryScreen> {
  String _searchQuery = '';
  late final Stream<List<CustomMeal>> _mealsStream;

  @override
  void initState() {
    super.initState();
    _mealsStream = SavedMealsService.instance.mealsStream;
    _checkAndShowSubscribeDialog();
  }
  
  Future<void> _checkAndShowSubscribeDialog() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();

    final isSub = (doc.data()?['suscribed'] as bool?) ?? false;
    if (!isSub) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSubscribeDialog();
      });
    }
  }

  void _showSubscribeDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.premiumFunctionTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(
                color: Colors.grey,
                thickness: 1.5,
                height: 1,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loc.subscribePrompt,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                    );
                  },
                  child: Text(
                    loc.subscribeButton,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(loc.myKitchenTitle, style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: loc.searchHint,
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CustomMeal>>(
              stream: _mealsStream,
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                final meals = snapshot.data!;
                final filteredMeals = _searchQuery.isEmpty
                    ? meals
                    : meals
                        .where((m) =>
                            m.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();

                if (_searchQuery.isNotEmpty && filteredMeals.isEmpty) {
                  return Center(
                    child: Text(
                      loc.searchNoResultsMessage,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (_searchQuery.isEmpty && meals.isEmpty) {
                  return Center(
                    child: Text(
                      loc.noRecipesMessage,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                    itemCount: filteredMeals.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 140,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return GestureDetector(
                        onTap: () => _showMealDialog(context, loc, meal),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            meal.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void _showMealDialog(
      BuildContext context, AppLocalizations loc, CustomMeal meal) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc.yourDish,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Divider(
                    color: Color.fromARGB(117, 48, 47, 47),
                    thickness: 1.5,
                    height: 20),
                _buildIngredientDetail(
                  context,
                  meal.main.name,
                  meal.mainGrams,
                  ((meal.mainGrams * meal.main.caloriesPer100g) / 100).round(),
                  (meal.mainGrams * meal.main.proteinPer100g / 100),
                ),
                if (meal.side1 != null && meal.side1Grams != null) ...[
                  const SizedBox(height: 12),
                  _buildIngredientDetail(
                    context,
                    meal.side1!.name,
                    meal.side1Grams!,
                    ((meal.side1Grams! * meal.side1!.caloriesPer100g) / 100)
                        .round(),
                    (meal.side1Grams! * meal.side1!.proteinPer100g / 100),
                  ),
                ],
                if (meal.side2 != null && meal.side2Grams != null) ...[
                  const SizedBox(height: 12),
                  _buildIngredientDetail(
                    context,
                    meal.side2!.name,
                    meal.side2Grams!,
                    ((meal.side2Grams! * meal.side2!.caloriesPer100g) / 100)
                        .round(),
                    (meal.side2Grams! * meal.side2!.proteinPer100g / 100),
                  ),
                ],
                if (meal.side3 != null && meal.side3Grams != null) ...[
                  const SizedBox(height: 12),
                  _buildIngredientDetail(
                    context,
                    meal.side3!.name,
                    meal.side3Grams!,
                    ((meal.side3Grams! * meal.side3!.caloriesPer100g) / 100)
                        .round(),
                    (meal.side3Grams! * meal.side3!.proteinPer100g / 100),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  loc.totalCalories(meal.totalCalories.toString()),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.totalProteins(meal.totalProtein.toStringAsFixed(1)),
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: Text(loc.delete),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: dialogContext,
                        builder: (confirmContext) => AlertDialog(
                          title: Text(loc.deleteConfirmationTitle),
                          content: Text(
                            loc.deleteConfirmationMessage(meal.name),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(confirmContext).pop(false),
                              child: Text(loc.cancel),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(confirmContext).pop(true),
                              child: Text(
                                loc.delete,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await SavedMealsService.instance.deleteMeal(meal.id);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientDetail(
    BuildContext context,
    String name,
    int grams,
    int calories,
    double protein,
  ) {
    return Column(
      children: [
        Text(
          '$name – $grams g',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          '$calories kcal, ${protein.toStringAsFixed(1)} g prot',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}
