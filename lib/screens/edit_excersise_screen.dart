import 'package:flutter/material.dart';
import 'package:fitness1945/services/database_service.dart';
import 'package:fitness1945/models/exercise.model.dart';

class EditExcersiseScreen extends StatefulWidget {
  final Exercise exercise;

  EditExcersiseScreen({required this.exercise});

  @override
  _EditExcersiseScreenState createState() => _EditExcersiseScreenState();
}

class _EditExcersiseScreenState extends State<EditExcersiseScreen> {
  late TextEditingController _nameController;
  late TextEditingController _setsController;
  late TextEditingController _repsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise.name);
    _setsController = TextEditingController(text: widget.exercise.sets.toString());
    _repsController = TextEditingController(text: widget.exercise.reps.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  // Funkcja do zapisywania zaktualizowanego ćwiczenia w bazie danych
  Future<void> _updateExercise() async {
    final updatedExercise = Exercise(
      id: widget.exercise.id,
      name: _nameController.text,
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      trainingId: widget.exercise.trainingId,
    );

    final db = await DatabaseService.instance.database;

    await db.update(
      'excersise',
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
