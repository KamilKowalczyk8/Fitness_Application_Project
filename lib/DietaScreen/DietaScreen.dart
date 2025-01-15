import 'package:flutter/material.dart';
import 'PersonScreen.dart'; // Importuj PersonScreen
import 'services_dieta/database_helper_dieta.dart'; // Importuj DatabaseHelper

class DietaScreen extends StatefulWidget {
  @override
  _DietaScreenState createState() => _DietaScreenState();
}

class _DietaScreenState extends State<DietaScreen> {
  double calorieRequirement = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCalorieRequirement();
  }

  Future<void> _fetchCalorieRequirement() async {
    final db = await DatabaseHelperDieta.instance.database;
    final List<Map<String, dynamic>> persons = await db.query('person');

    if (persons.isNotEmpty) {
      final person = persons.first;
      final String gender = person['gender'];
      final int activityLevel = person['activity_level'];
      final double height = person['height'];
      final double weight = person['weight'];

      double bmr;
      if (gender == 'male') {
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * 30);
      } else {
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * 30);
      }

      double activityMultiplier;
      switch (activityLevel) {
        case 0:
          activityMultiplier = 1.2;
          break;
        case 1:
          activityMultiplier = 1.375;
          break;
        case 2:
          activityMultiplier = 1.55;
          break;
        case 3:
          activityMultiplier = 1.725;
          break;
        case 4:
          activityMultiplier = 1.9;
          break;
        default:
          activityMultiplier = 1.2;
          break;
      }

      setState(() {
        calorieRequirement = (bmr * activityMultiplier).toInt().toDouble();
      });
    } else {
      setState(() {
        calorieRequirement = 0.0;
      });
    }
  }

  void _onDataUpdated() {
    _fetchCalorieRequirement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dieta'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 8.0), // Przesunięcie ikonki
            child: IconButton(
              icon: Icon(Icons.person, size: 36.0), // Zwiększony rozmiar ikonki
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonScreen(onDataUpdated: _onDataUpdated)),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Twoje zapotrzebowanie',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            '${calorieRequirement.toInt()} kcal',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: Text('W fazie rozwoju'),
            ),
          ),
        ],
      ),
    );
  }
}
