import 'package:flutter/material.dart';
import 'MealFormScreen.dart'; // Importuj ekran formularza posiłku
import 'package:fitness1945/DietaScreen/services_dieta/database_helper_dieta.dart';
import 'package:fitness1945/DietaScreen/services_dieta/database_helper_day.dart';

class AddMealScreen extends StatefulWidget {
  final String date;

  AddMealScreen({required this.date});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  double calorieRequirement = 2000.0;
  double protein = 150.0;
  double carbs = 250.0;
  double fats = 70.0;
  List<Map<String, dynamic>> meals = [];

  double consumedCalories = 0.0;
  double consumedProtein = 0.0;
  double consumedCarbs = 0.0;
  double consumedFats = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPersonData();
    _fetchMealsForDay();
  }

  Future<void> _loadPersonData() async {
    final db = await DatabaseHelperDieta.instance.database;
    final List<Map<String, dynamic>> persons = await db.query('person');
    if (persons.isNotEmpty) {
      final person = persons.first;
      setState(() {
        calorieRequirement = person['calorieRequirement'] ?? 2000.0;
        protein = person['protein'] ?? 150.0;
        carbs = person['carbs'] ?? 250.0;
        fats = person['fats'] ?? 70.0;
      });
    }
  }

  Future<void> _fetchMealsForDay() async {
    final meals = await DatabaseHelperDay.instance.getMealsForDay(widget.date);
    setState(() {
      this.meals = meals;

      consumedCalories = 0.0;
      consumedProtein = 0.0;
      consumedCarbs = 0.0;
      consumedFats = 0.0;

      for (var meal in meals) {
        consumedCalories += meal['calories'];
        consumedProtein += meal['protein'];
        consumedCarbs += meal['carbs'];
        consumedFats += meal['fat'];
      }

      consumedCalories = _formatValue(consumedCalories);
      consumedProtein = _formatValue(consumedProtein);
      consumedCarbs = _formatValue(consumedCarbs);
      consumedFats = _formatValue(consumedFats);
    });
  }

  double _formatValue(double value) {
    return value % 1 == 0 ? value.toInt().toDouble() : value;
  }

  String _formatDisplayValue(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  void _navigateToMealForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealFormScreen(date: widget.date),
      ),
    );

    if (result != null) {
      _fetchMealsForDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: meals.length + 1, // Zwiększ liczbę elementów o 1
              itemBuilder: (context, index) {
                if (index < meals.length) {
                  final meal = meals[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text('${meal['mealType']} (${meal['mealWeight']}g)'),
                      subtitle: Text(
                        'Pora posiłku: ${meal['mealTime']}\nKalorie: ${meal['calories']} kcal, Węglowodany: ${meal['carbs']} g, Białko: ${meal['protein']} g, Tłuszcz: ${meal['fat']} g',
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _navigateToMealForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Kolor tła
                          foregroundColor: Colors.white, // Kolor tekstu
                        ),
                        child: Text('Dodaj Posiłek'),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blueAccent,
            child: Column(
              children: [
                _buildNutrientRow('Kalorie', consumedCalories, calorieRequirement),
                SizedBox(height: 16.0),
                _buildNutrientRow('Białko', consumedProtein, protein),
                SizedBox(height: 16.0),
                _buildNutrientRow('Węglowodany', consumedCarbs, carbs),
                SizedBox(height: 16.0),
                _buildNutrientRow('Tłuszcze', consumedFats, fats),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String label, double consumed, double requirement) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_formatDisplayValue(consumed)}/${requirement.toInt()}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: consumed / requirement,
          backgroundColor: Colors.white,
          color: consumed <= requirement ? Colors.green : Colors.red,
          minHeight: 10.0,
        ),
      ],
    );
  }
}
