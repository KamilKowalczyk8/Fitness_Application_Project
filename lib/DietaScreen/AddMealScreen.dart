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
  double calorieRequirement = 2000.0; // Przykładowe wartości
  double protein = 150.0; // Przykładowe wartości
  double carbs = 250.0; // Przykładowe wartości
  double fats = 70.0; // Przykładowe wartości
  List<Map<String, dynamic>> meals = [];

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
    });
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
      appBar: AppBar(
        title: Text('Dodaj Posiłek'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Dodaj posiłki: ${widget.date.substring(0, 10)}',
              style: TextStyle(fontSize: 18),
            ),
          ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Kalorie',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${calorieRequirement.toInt()} kcal',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Białko',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${protein.toInt()} g',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Węglowodany',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${carbs.toInt()} g',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Tłuszcze',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${fats.toInt()} g',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
