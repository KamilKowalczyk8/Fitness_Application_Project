import 'package:flutter/material.dart';
import 'package:fitness1945/DietaScreen/services_dieta/database_helper_day.dart';
import 'package:fitness1945/DietaScreen/services_dieta/database_helper_food.dart';

class MealFormScreen extends StatefulWidget {
  final String date;

  MealFormScreen({required this.date});

  @override
  _MealFormScreenState createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String mealTime = 'Śniadanie';
  String mealWeight = '';
  String mealType = '';
  final List<String> mealTimes = [
    'Śniadanie',
    'Drugie śniadanie',
    'Lunch',
    'Obiad',
    'Przekąska',
    'Kolacja',
  ];
  List<String> mealTypes = [];
  double calculatedCalories = 0;
  double calculatedCarbs = 0;
  double calculatedProtein = 0;
  double calculatedFat = 0;

  @override
  void initState() {
    super.initState();
    _loadMealTypes();
  }

  void _loadMealTypes() async {
    List<String> types = await DatabaseHelperFood.instance.getFoodNames();
    print('Loaded meal types: $types'); // Debugging output
    setState(() {
      mealTypes = types;
    });
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _calculateNutritionValues();

      final meal = {
        'dayId': await _getDayId(),
        'mealTime': mealTime,
        'mealWeight': mealWeight,
        'mealType': mealType,
        'calories': calculatedCalories,
        'carbs': calculatedCarbs,
        'protein': calculatedProtein,
        'fat': calculatedFat,
      };

      await DatabaseHelperDay.instance.addMeal(meal);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Posiłek dodany: $mealType, $mealWeight g, $mealTime')),
      );

      Navigator.pop(context, true);
    }
  }

  Future<void> _calculateNutritionValues() async {
    final db = await DatabaseHelperFood.instance.database;
    List<Map<String, dynamic>> foodData = await db.query(
      'food',
      where: 'name = ?',
      whereArgs: [mealType],
    );

    if (foodData.isNotEmpty) {
      final food = foodData.first;
      double weight = double.parse(mealWeight);
      setState(() {
        calculatedCalories = (food['calories'] * weight) / 100;
        calculatedCarbs = (food['carbs'] * weight) / 100;
        calculatedProtein = (food['protein'] * weight) / 100;
        calculatedFat = (food['fat'] * weight) / 100;
      });
    }
  }

  Future<int> _getDayId() async {
    final db = await DatabaseHelperDay.instance.database;
    final List<Map<String, dynamic>> days = await db.query(
      'days',
      where: 'date LIKE ?',
      whereArgs: [widget.date],
    );

    if (days.isNotEmpty) {
      return days.first['id'];
    } else {
      final newDay = {'date': widget.date};
      return await db.insert('days', newDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj Posiłek'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Pora posiłku'),
                value: mealTime,
                items: mealTimes.map((String meal) {
                  return DropdownMenuItem<String>(
                    value: meal,
                    child: Text(meal),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    mealTime = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wybrać porę posiłku';
                  }
                  return null;
                },
                onSaved: (value) {
                  mealTime = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gramatura (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać gramaturę';
                  }
                  return null;
                },
                onSaved: (value) {
                  mealWeight = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Rodzaj jedzenia'),
                value: mealType.isNotEmpty ? mealType : null,
                items: mealTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    mealType = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wybrać rodzaj jedzenia';
                  }
                  return null;
                },
                onSaved: (value) {
                  mealType = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text('Zapisz Posiłek'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
