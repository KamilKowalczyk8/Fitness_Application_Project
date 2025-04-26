import 'package:flutter/material.dart';
import 'package:fitness1945/CoachScreens/screensCoach/add_dependent_screen.dart';
import 'package:fitness1945/CoachScreens/CoachModel/dependent.model.dart';
import 'package:fitness1945/CoachScreens/services_coach/dependent_database.dart';
import 'package:fitness1945/CoachScreens/screensCoach/create_training_screen_dependent.dart';

class CoachMainScreen extends StatefulWidget {
  @override
  _CoachMainScreenState createState() => _CoachMainScreenState();
}

class _CoachMainScreenState extends State<CoachMainScreen> {
  late Future<List<Dependent>> _dependents;

  @override
  void initState() {
    super.initState();
    _loadDependents();
  }

  void _loadDependents() {
    setState(() {
      _dependents = DatabaseService.instance.getDependents();
    });
  }

  void _deleteDependent(int id) async {
    await DatabaseService.instance.deleteDependent(id);
    _loadDependents(); // Odśwież listę po usunięciu
  }

  void _confirmDeleteDependent(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Usunięcie podopiecznego'),
        content: Text('Czy na pewno chcesz usunąć tego podopiecznego?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              _deleteDependent(id);
              Navigator.pop(context);
            },
            child: Text('Usuń'),
          ),
        ],
      ),
    );
  }

  void _editDependent(Dependent dependent) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDependentScreen(dependent: dependent)),
    );
    if (result == true) {
      setState(() {
        _loadDependents();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Podopieczni')),
      body: FutureBuilder<List<Dependent>>(
        future: _dependents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Błąd ładowania danych'));
          }
          final dependents = snapshot.data ?? [];
          return ListView.builder(
            itemCount: dependents.length,
            itemBuilder: (context, index) {
              final dependent = dependents[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateTrainingScreenDependent(dependent: dependent)),
                    );
                  },
                  child: ListTile(
                    title: Text(dependent.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data Urodzenia: ${dependent.ageOrDob}'),
                        Text('Status: ${dependent.status}'),
                        Text('Poziom/Cel: ${dependent.levelOrGoal}'),
                        Text('Kontakt: ${dependent.contact}'),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'edit') {
                          _editDependent(dependent);
                        } else if (value == 'delete') {
                          _confirmDeleteDependent(dependent.id!);
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
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDependentScreen()),
          );
          if (result == true) {
            setState(() {
              _loadDependents();
            });
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}
