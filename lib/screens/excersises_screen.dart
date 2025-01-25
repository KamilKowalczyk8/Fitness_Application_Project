import 'package:flutter/material.dart';
import 'package:fitness1945/screens/exercise_tutorial_screen.dart'; 
import 'package:fitness1945/services/database_service.dart'; 
import 'package:fitness1945/models/exercise.model.dart'; 
import 'add_excersise_screen.dart'; 
import 'package:fitness1945/screens/add_excersise_screen.dart';
import 'edit_excersise_screen.dart'; 

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
    _exercises = _loadExercises(); 
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
                trailing: PopupMenuButton<String>(
                  onSelected: (String value) {
                    if (value == 'edit') {
                      _editExercise(exercise);
                    } else if (value == 'delete') {
                      _confirmDeleteExercise(exercise);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edytuj'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Usuń'),
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
                  child: Text(
                    'Poradnik do ćwiczeń',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), 
                    textStyle: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                FloatingActionButton(
                  onPressed: _addExercise,
                  child: Icon(
                    Icons.add,
                    color: Colors.white, 
                  ),
                  backgroundColor: Colors.greenAccent,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
