import 'package:flutter/material.dart';
import 'services_dieta/database_helper_dieta.dart'; // Importuj DatabaseHelper

class PersonScreen extends StatefulWidget {
  final VoidCallback onDataUpdated;

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
                      widget.onDataUpdated();

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
