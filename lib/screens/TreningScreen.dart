import 'package:flutter/material.dart';
import 'add_trening_screen.dart';
import 'excersises_screen.dart';

class TreningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Przykładowe dane treningu, w tym treningId
    final treningi = [
      {'id': 1, 'name': 'Trening 1', 'description': 'Opis treningu'},
      {'id': 2, 'name': 'Trening 2', 'description': 'Inny opis treningu'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Treningi')),
      body: ListView.builder(
        itemCount: treningi.length,
        itemBuilder: (context, index) {
          final trening = treningi[index];

          // Rzutowanie na odpowiednie typy
          final String treningName = trening['name'] as String;
          final String treningDescription = trening['description'] as String;
          final int treningId = trening['id'] as int;

          return ListTile(
            title: Text(treningName),
            subtitle: Text(treningDescription),
            trailing: ElevatedButton(
              onPressed: () {
                // Przekazujemy treningId do ExcersisesScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExcersisesScreen(treningId: treningId),
                  ),
                );
              },
              child: Text('Zobacz'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTreningScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
