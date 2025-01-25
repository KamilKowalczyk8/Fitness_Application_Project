import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fitness1945/services/database_service.dart';
import 'package:fitness1945/models/exercise.model.dart';

class AddExerciseScreen extends StatefulWidget {
  final int trainingId;

  AddExerciseScreen({required this.trainingId});

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  String _weightUnit = 'kg';

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
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Obciążenie'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _weightUnit,
              items: ['kg', 'lbs'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _weightUnit = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
               
                print('Nazwa ćwiczenia: ${_nameController.text}');
                print('Ilość serii: ${_setsController.text}');
                print('Ilość powtórzeń: ${_repsController.text}');
                print('Obciążenie: ${_weightController.text} $_weightUnit');

               
                final newExercise = Exercise(
                  name: _nameController.text,
                  sets: int.parse(_setsController.text),
                  reps: int.parse(_repsController.text),
                  weight: double.parse(_weightController.text),
                  weightUnit: _weightUnit,
                  trainingId: widget.trainingId,
                );

               
                await _saveExercise(newExercise);

               
                Navigator.pop(context, true);
              },
              child: Text(
                'Dodaj',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white, 
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), 
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveExercise(Exercise exercise) async {
    final db = await DatabaseService.instance.database;

    await db.insert(
      'exercise',
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
