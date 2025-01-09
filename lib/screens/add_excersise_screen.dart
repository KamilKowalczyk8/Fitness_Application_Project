import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Dodaj ten import
import 'package:fitness1945/services/database_service.dart';
import 'package:fitness1945/models/exercise.model.dart';// Importuj model ćwiczenia

class AddExcersiseScreen extends StatefulWidget {
  final int treningId;

  AddExcersiseScreen({required this.treningId});

  @override
  _AddExcersiseScreenState createState() => _AddExcersiseScreenState();
}

class _AddExcersiseScreenState extends State<AddExcersiseScreen> {
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dodaj Ćwiczenie')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nazwa Ćwiczenia'),
            ),
            TextField(
              controller: _setsController,
              decoration: InputDecoration(labelText: 'Ilość serii'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _repsController,
              decoration: InputDecoration(labelText: 'Ilość powtórzeń'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                // Logowanie wartości przed zapisaniem
                print('Nazwa ćwiczenia: ${_nameController.text}');
                print('Ilość serii: ${_setsController.text}');
                print('Ilość powtórzeń: ${_repsController.text}');

                // Tworzenie obiektu ćwiczenia
                final newExercise = Exercise(
                  name: _nameController.text,
                  sets: int.parse(_setsController.text),
                  reps: int.parse(_repsController.text),
                  trainingId: widget.treningId,
                );

                // Zapisz ćwiczenie w bazie danych
                _saveExercise(newExercise);

                // Powrót do poprzedniego ekranu
                Navigator.pop(context);
              },
              child: Text('Dodaj'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveExercise(Exercise exercise) async {
    final db = await DatabaseService.instance.database;

    await db.insert(
      'excersise',
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
