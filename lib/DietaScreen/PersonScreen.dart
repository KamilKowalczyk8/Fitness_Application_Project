import 'package:flutter/material.dart';
import 'services_dieta/database_helper_dieta.dart'; 

class PersonScreen extends StatefulWidget {
  final Function(double, double, double, double) onDataUpdated;

  PersonScreen({required this.onDataUpdated});

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  String gender = "male";
  int activityLevel = 0;
  String? height;
  String? weight;
  int? personId;

  final List<String> activityLevels = [
    "Siedzący tryb życia",
    "Lekko aktywny",
    "Średnio aktywny",
    "Bardzo aktywny",
    "Ekstremalnie aktywny",
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadPerson();
  }

  Future<void> _loadPerson() async {
    final db = await DatabaseHelperDieta.instance.database;
    final List<Map<String, dynamic>> persons = await db.query('person');
    if (persons.isNotEmpty) {
      final person = persons.first;
      setState(() {
        gender = person['gender'];
        activityLevel = person['activity_level'];
        height = person['height'].toString();
        weight = person['weight'].toString();
        personId = person['id'];
      });
    }
  }

  void _calculateAndUpdateData() {
    double heightValue = double.parse(height!);
    double weightValue = double.parse(weight!);

    double bmr;
    if (gender == 'male') {
      bmr = 88.362 + (13.397 * weightValue) + (4.799 * heightValue) - (5.677 * 30);
    } else {
      bmr = 447.593 + (9.247 * weightValue) + (3.098 * heightValue) - (4.330 * 30);
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

    double calorieReq = bmr * activityMultiplier;
    double protein = (calorieReq * 0.20) / 4;
    double carbs = (calorieReq * 0.50) / 4;
    double fats = (calorieReq * 0.30) / 9;

    widget.onDataUpdated(calorieReq, protein, carbs, fats);

    if (personId != null) {
      _updatePersonData(calorieReq, protein, carbs, fats);
    }
  }

  Future<void> _updatePersonData(double calorieReq, double protein, double carbs, double fats) async {
    final db = await DatabaseHelperDieta.instance.database;
    await db.update(
      'person',
      {
        'calorieRequirement': calorieReq,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
      },
      where: 'id = ?',
      whereArgs: [personId],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Płeć:"),
              ListTile(
                title: const Text('Mężczyzna'),
                leading: Radio<String>(
                  value: "male",
                  groupValue: gender,
                  onChanged: (String? value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Kobieta'),
                leading: Radio<String>(
                  value: "female",
                  groupValue: gender,
                  onChanged: (String? value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              Text("Poziom aktywności:"),
              for (int i = 0; i < activityLevels.length; i++)
                ListTile(
                  title: Text(activityLevels[i]),
                  leading: Radio<int>(
                    value: i,
                    groupValue: activityLevel,
                    onChanged: (int? value) {
                      setState(() {
                        activityLevel = value!;
                      });
                    },
                  ),
                ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: height,
                decoration: InputDecoration(
                  labelText: 'Wzrost (cm)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  height = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wprowadź wzrost';
                  }
                  final n = num.tryParse(value);
                  if (n == null) {
                    return 'Wprowadź poprawny wzrost';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: weight,
                decoration: InputDecoration(
                  labelText: 'Waga (kg)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  weight = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wprowadź wagę';
                  }
                  final n = num.tryParse(value);
                  if (n == null) {
                    return 'Wprowadź poprawną wagę';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final person = {
                        'gender': gender,
                        'activity_level': activityLevel,
                        'height': double.parse(height!),
                        'weight': double.parse(weight!),
                      };

                      if (personId != null) {
                        person['id'] = personId!;
                        await DatabaseHelperDieta.instance.updatePerson(person);
                      } else {
                        await DatabaseHelperDieta.instance.insertPerson(person);
                      }
                      _calculateAndUpdateData();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Dane zapisane')),
                      );
                    }
                  },
                  child: Text('Zapisz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
