import 'package:flutter/material.dart';
import 'package:fitness1945/screens/add_trening_screen.dart';
import 'package:fitness1945/screens/excersises_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fitness1945/models/trening.model.dart';
import 'package:fitness1945/services/database_service.dart';
import 'package:path/path.dart' as p; 
import 'package:intl/intl.dart'; 

class TreningScreen extends StatefulWidget {
  @override
  _TreningScreenState createState() => _TreningScreenState();
}

class _TreningScreenState extends State<TreningScreen> {
  late Future<List<Trening>> _treningi;

  @override
  void initState() {
    super.initState();
    _loadTreningi();
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'fitness.db'); 
    await deleteDatabase(path);
  }

  void _loadTreningi() {
    setState(() {
      _treningi = DatabaseService.instance.database.then((db) async {
        final List<Map<String, dynamic>> maps = await db.query('trening');
        return maps.map((map) => Trening.fromMap(map)).toList();
      });
    });
  }

  // Funkcja do usuwania treningu
  void _deleteTrening(int id) async {
    final db = await DatabaseService.instance.database;
    await db.delete(
      'trening',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadTreningi(); 
  }

  
  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    final format = DateFormat('yyyy-MM-dd   HH:mm'); 
    return format.format(dateTime);
  }

  void _confirmDeleteTrening(int id) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Usunięcie treningu'),
        content: Text('Czy na pewno chcesz usunąć ten trening?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              _deleteTrening(id); 
              Navigator.pop(context); 
            },
            child: Text('Usuń'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Treningi')),
      body: FutureBuilder<List<Trening>>(
        future: _treningi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Błąd ładowania danych'));
          }
          final treningi = snapshot.data ?? [];
          return ListView.builder(
            itemCount: treningi.length,
            itemBuilder: (context, index) {
              final trening = treningi[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExcersisesScreen(trainingId: trening.id!)),
                    );
                  },
                  child: ListTile(
                    title: Text(trening.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trening.description),
                        Text('Utworzono: ${_formatDate(trening.date)}'), 
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'delete') {
                          _confirmDeleteTrening(trening.id!);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
            MaterialPageRoute(builder: (context) => AddTreningScreen()),
          );
          if (result == true) {
            setState(() {
              _loadTreningi();
            });
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white, 
        ),
        backgroundColor: Colors.greenAccent, 
      ),
    );
  }
}
