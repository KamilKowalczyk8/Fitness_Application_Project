import 'package:flutter/material.dart';
import 'package:fitness1945/screens/exercise_tutorial_screen.dart'; // Poprawny import
import 'package:fitness1945/services/database_service.dart'; // Importuj usługę bazy danych
import 'package:fitness1945/models/exercise.model.dart'; // Importuj model ćwiczenia
import 'add_excersise_screen.dart'; // Importuj ekran dodawania ćwiczenia
import 'package:fitness1945/screens/add_excersise_screen.dart';

import 'edit_excersise_screen.dart'; // Importuj ekran edytowania ćwiczenia

class ExcersisesScreen extends StatefulWidget {
  final int trainingId;

  ExcersisesScreen({required this.trainingId});

  @override
  _ExcersisesScreenState createState() => _ExcersisesScreenState();
}

class _ExcersisesScreenState extends State<ExcersisesScreen> {
  late Future<List<Exercise>> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = _loadExercises(); // Załaduj ćwiczenia z bazy danych
  }

  Future<List<Exercise>> _loadExercises() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercise',
      where: 'training_id = ?',
      whereArgs: [widget.trainingId],
    );

    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  void _editExercise(Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExerciseScreen(exercise: exercise),
      ),
    );
  }

  void _confirmDeleteExercise(Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Usunięcie ćwiczenia'),
          content: Text('Czy na pewno chcesz usunąć to ćwiczenie?'),
          actions: <Widget>[
            TextButton(
              child: Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Usuń'),
              onPressed: () {
                _deleteExercise(exercise);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteExercise(Exercise exercise) async {
    final db = await DatabaseService.instance.database;

    await db.delete(
      'exercise',
      where: 'id = ?',
      whereArgs: [exercise.id],
    );

    setState(() {
      _exercises = _loadExercises();
    });
  }

  void _addExercise() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExerciseScreen(trainingId: widget.trainingId),
      ),
    );

    if (result == true) {
      setState(() {
        _exercises = _loadExercises();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ćwiczenia')),
      body: FutureBuilder<List<Exercise>>(
        future: _exercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Błąd ładowania ćwiczeń'));
          }

          final exercises = snapshot.data ?? [];

          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return ListTile(
                title: Text(exercise.name),
                subtitle: Text('${exercise.sets} serie, ${exercise.reps} powtórzeń, ${exercise.weight} ${exercise.weightUnit}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editExercise(exercise);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmDeleteExercise(exercise);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseTutorialScreen(),
                      ),
                    );
                  },
                  child: Text('Poradnik do ćwiczeń'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFADD8E6),
                  ),
                ),
                FloatingActionButton(
                  onPressed: _addExercise,
                  child: Icon(Icons.add),
                  backgroundColor: Color(0xFFEADDFF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
