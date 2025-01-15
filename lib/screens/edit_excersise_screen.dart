import 'package:flutter/material.dart';
import 'package:fitness1945/services/database_service.dart';
import 'package:fitness1945/models/exercise.model.dart';

class EditExerciseScreen extends StatefulWidget {
  final Exercise exercise;

  EditExerciseScreen({required this.exercise});

  @override
  _EditExerciseScreenState createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  late TextEditingController _nameController;
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _weightController; // Dodajemy kontroler dla wagi

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise.name);
    _setsController = TextEditingController(text: widget.exercise.sets.toString());
    _repsController = TextEditingController(text: widget.exercise.reps.toString());
    _weightController = TextEditingController(text: widget.exercise.weight.toString()); // Inicjalizujemy kontroler dla wagi
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose(); // Zwalniamy kontroler dla wagi
    super.dispose();
  }

  // Funkcja do zapisywania zaktualizowanego ćwiczenia w bazie danych
  Future<void> _updateExercise() async {
    final updatedExercise = Exercise(
      id: widget.exercise.id,
      name: _nameController.text,
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      weight: double.parse(_weightController.text), // Dodajemy wagę
      trainingId: widget.exercise.trainingId,
      weightUnit: widget.exercise.weightUnit, // Dodajemy jednostkę wagi
    );

    final db = await DatabaseService.instance.database;

    await db.update(
      'exercise',
      updatedExercise.toMap(),
      where: 'id = ?',
      whereArgs: [updatedExercise.id],
    );

    // Po zapisaniu zmiany, wracamy do poprzedniego ekranu
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edytuj Ćwiczenie')),
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
              controller: _weightController, // Pole dla wagi
              decoration: InputDecoration(labelText: 'Waga'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateExercise(); // Zaktualizuj ćwiczenie
              },
              child: Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }
}
