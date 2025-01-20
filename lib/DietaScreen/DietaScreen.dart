import 'package:flutter/material.dart';
import 'PersonScreen.dart';
import 'services_dieta/database_helper_dieta.dart';
import 'services_dieta/database_helper_day.dart';
import 'AddMealScreen.dart';
import 'package:intl/intl.dart';

class DietaScreen extends StatefulWidget {
  @override
  _DietaScreenState createState() => _DietaScreenState();
}

class _DietaScreenState extends State<DietaScreen> {
  double calorieRequirement = 0.0; // Domyślne wartości
  double protein = 0.0; // Domyślne wartości
  double carbs = 0.0; // Domyślne wartości
  double fats = 0.0; // Domyślne wartości
  List<Map<String, dynamic>> days = [];

  @override
  void initState() {
    super.initState();
    _loadPersonData();
    _fetchDays();
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

  Future<void> _fetchDays() async {
    final db = await DatabaseHelperDay.instance.database;
    final List<Map<String, dynamic>> fetchedDays = await db.query('days');

    setState(() {
      days = List<Map<String, dynamic>>.from(fetchedDays);
    });
  }

  void _addDay() async {
    final db = await DatabaseHelperDay.instance.database;
    final today = DateTime.now().toIso8601String().split('T').first;
    final List<Map<String, dynamic>> existingDays = await db.query(
      'days',
      where: 'date LIKE ?',
      whereArgs: ['$today%'],
    );

    if (existingDays.isEmpty) {
      final newDay = {'date': DateTime.now().toIso8601String()};
      await db.insert('days', newDay);

      setState(() {
        days.add(newDay);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Posiłek na ten dzień już został dodany!')),
      );
    }
  }

  String _formatDate(String dateStr) {
    final DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  String _formatValue(double value) {
    return value.toStringAsFixed(1); // Formatuje wartość do jednego miejsca po przecinku
  }

  Future<Map<String, double>> _fetchMealsDataForDay(String date) async {
    final meals = await DatabaseHelperDay.instance.getMealsForDay(date);
    double consumedCalories = 0.0;
    double consumedProtein = 0.0;
    double consumedCarbs = 0.0;
    double consumedFats = 0.0;

    for (var meal in meals) {
      consumedCalories += meal['calories'];
      consumedProtein += meal['protein'];
      consumedCarbs += meal['carbs'];
      consumedFats += meal['fat'];
    }

    return {
      'calories': consumedCalories,
      'protein': consumedProtein,
      'carbs': consumedCarbs,
      'fats': consumedFats,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diety'),
        centerTitle: true, // Wyśrodkowanie tytułu
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 8.0), // Przesunięcie ikonki
            child: IconButton(
              icon: Icon(Icons.person, size: 36.0), // Zwiększony rozmiar ikonki
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonScreen(
                      onDataUpdated: (calorieReq, protein, carbs, fats) async {
                        setState(() {
                          calorieRequirement = calorieReq;
                          this.protein = protein;
                          this.carbs = carbs;
                          this.fats = fats;
                        });

                        final person = {
                          'calorieRequirement': calorieReq,
                          'protein': protein,
                          'carbs': carbs,
                          'fats': fats,
                        };

                        final db = await DatabaseHelperDieta.instance.database;
                        await db.update('person', person);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: days.length + 1, // Dodajemy 1 do liczby dni, żeby pomieścić przycisk
              itemBuilder: (context, index) {
                if (index < days.length) {
                  final day = days[index];
                  return FutureBuilder<Map<String, double>>(
                    future: _fetchMealsDataForDay(day['date']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Błąd ładowania danych'));
                      }
                      final data = snapshot.data ?? {
                        'calories': 0.0,
                        'protein': 0.0,
                        'carbs': 0.0,
                        'fats': 0.0,
                      };
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Center(
                            child: Column(
                              children: [
                                Text(
                                  _formatDate(day['date']),
                                  style: TextStyle(fontWeight: FontWeight.bold), // Data pogrubiona
                                ),
                                Text(
                                  'Kalorie: ${_formatValue(data['calories']!)}/${calorieRequirement.toInt()} kcal\n'
                                      'Białko: ${_formatValue(data['protein']!)}/${protein.toInt()} g\n'
                                      'Węglowodany: ${_formatValue(data['carbs']!)}/${carbs.toInt()} g\n'
                                      'Tłuszcze: ${_formatValue(data['fats']!)}/${fats.toInt()} g',
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14), // Normalna czcionka
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMealScreen(
                                  date: day['date'], // Przekazanie istniejącej daty
                                ),
                              ),
                            );
                          },
                        ),
                      );

                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _addDay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Kolor tła
                        foregroundColor: Colors.white, // Kolor tekstu
                      ),
                      child: Text('Dodaj dzień'),
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
                  children:    [
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
