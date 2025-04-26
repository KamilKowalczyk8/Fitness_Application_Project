import 'package:flutter/material.dart';
import '../DietaScreen/DietaScreen.dart';
import '../CoachScreens/screensCoach/CoachMainScreen.dart';
import 'TreningScreen.dart';
import '../HealthScreens/HealthScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wybierz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(context, 'Dieta', Colors.blueAccent, DietaScreen()),
              SizedBox(height: 20),
              _buildButton(context, 'Trening', Colors.greenAccent, TreningScreen()),
              SizedBox(height: 20),
              _buildButton(context, 'Zdrowie', Colors.orangeAccent, HealthScreen()),
              SizedBox(height: 20),
              _buildButton(context, 'Trenerzy', Colors.purpleAccent, CoachMainScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, Widget destination) {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Text(text),
      ),
    );
  }
}
