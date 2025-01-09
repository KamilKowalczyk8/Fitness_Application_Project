import 'package:flutter/material.dart';
import 'DietaScreen.dart';
import 'TreningScreen.dart';
import 'HealthScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DietaScreen()),
                );
              },
              child: Text('Dieta'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TreningScreen()),
                );
              },
              child: Text('Trening'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HealthScreen()),
                );
              },
              child: Text('Zdrowie'),
            ),
          ],
        ),
      ),
    );
  }
}
