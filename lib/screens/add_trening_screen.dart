import 'package:flutter/material.dart';
import 'package:fitness1945/services/database_service.dart';


class AddTreningScreen extends StatefulWidget {
  @override
  _AddTreningScreenState createState() => _AddTreningScreenState();
}

class _AddTreningScreenState extends State<AddTreningScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dodaj Trening')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Tytuł'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać tytuł';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Opis'),
                onSaved: (value) => _description = value ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final db = await DatabaseService.instance.database;
                    await db.insert(
                      'trening',
                      {
                        'name': _title,
                        'description': _description,
                        'date': DateTime.now().toIso8601String(),
                      },
                    );

                    Navigator.pop(context, true); // Powrót z wynikiem true
                  }
                },
                child: Text('Dodaj'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
