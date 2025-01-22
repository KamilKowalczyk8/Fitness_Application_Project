import 'package:flutter/material.dart';
import 'ReminderScreen.dart';  // Dodaj ten import

class HealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zdrowie'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),  // Ikonka serca
            iconSize: 36.0,  // Powiększenie ikony
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderScreen()),  // Nawigacja do ReminderScreen
              );
            },
          ),
        ],
      ),
      body: Center(child: Text('W fazie rozwoju')),
    );
  }
}
