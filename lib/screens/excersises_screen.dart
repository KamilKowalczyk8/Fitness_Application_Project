import 'package:flutter/material.dart';
import 'package:fitness1945/services/database_service.dart'; // Importuj usługę bazy danych
import 'package:fitness1945/models/exercise.model.dart'; // Importuj model ćwiczenia
import 'add_excersise_screen.dart'; // Importuj ekran dodawania ćwiczenia
import 'edit_excersise_screen.dart'; // Importuj ekran edytowania ćwiczenia

class ExcersisesScreen extends StatefulWidget {
  final int treningId;

  ExcersisesScreen({required this.treningId});

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
      'excersise',
      where: 'trening_id = ?',
      whereArgs: [widget.treningId],
    );

    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  // Funkcja edytowania ćwiczenia
  void _editExercise(Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExcersiseScreen(exercise: exercise),
      ),
    );
  }

  // Funkcja usuwania ćwiczenia z bazy danych
  void _confirmDeleteExercise(Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Potwierdzenie usunięcia'),
          content: Text('Czy na pewno chcesz usunąć to ćwiczenie?'),
          actions: <Widget>[
            TextButton(
              child: Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop(); // Zamknięcie okna dialogowego
              },
            ),
            TextButton(
              child: Text('Usuń'),
              onPressed: () {
                _deleteExercise(exercise);
                Navigator.of(context).pop(); // Zamknięcie okna dialogowego
              },
            ),
          ],
        );
      },
    );
  }

  // Funkcja usuwania ćwiczenia z bazy danych
  Future<void> _deleteExercise(Exercise exercise) async {
    final db = await DatabaseService.instance.database;

    // Usunięcie ćwiczenia z bazy danych
    await db.delete(
      'excersise',
      where: 'id = ?',
      whereArgs: [exercise.id],
    );

    // Odświeżenie listy ćwiczeń po usunięciu
    setState(() {
      _exercises = _loadExercises();
    });
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
                subtitle: Text('${exercise.sets} serie, ${exercise.reps} powtórzeń'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Przycisk edytowania
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editExercise(exercise); // Przekierowanie do edycji
                      },
                    ),
                    // Przycisk usuwania
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmDeleteExercise(exercise); // Potwierdzenie usunięcia
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExcersiseScreen(treningId: widget.treningId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
