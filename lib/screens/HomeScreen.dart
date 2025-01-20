import 'package:flutter/material.dart';
import '../DietaScreen/DietaScreen.dart';
import '../CoachScreens/CoachMainScreen.dart';
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
            fontSize: 24, // Zwiększony rozmiar czcionki
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: SizedBox(
                    width: 200, // Szerokość przycisków
                    height: 60, // Wysokość przycisków
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Kolor tła przycisku
                        foregroundColor: Colors.white, // Kolor tekstu
                        textStyle: TextStyle(
                          fontSize: 24, // Zwiększony rozmiar czcionki
                          fontWeight: FontWeight.bold, // Pogrubienie tekstu
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Zaokrąglone rogi
                        ),
                        elevation: 5, // Cieniowanie
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DietaScreen()),
                        );
                      },
                      child: Text('Dieta'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent, // Kolor tła przycisku
                        foregroundColor: Colors.white, // Kolor tekstu
                        textStyle: TextStyle(
                          fontSize: 24, // Zwiększony rozmiar czcionki
                          fontWeight: FontWeight.bold, // Pogrubienie tekstu
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Zaokrąglone rogi
                        ),
                        elevation: 5, // Cieniowanie
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TreningScreen()),
                        );
                      },
                      child: Text('Trening'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent, // Kolor tła przycisku
                        foregroundColor: Colors.white, // Kolor tekstu
                        textStyle: TextStyle(
                          fontSize: 24, // Zwiększony rozmiar czcionki
                          fontWeight: FontWeight.bold, // Pogrubienie tekstu
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Zaokrąglone rogi
                        ),
                        elevation: 5, // Cieniowanie
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HealthScreen()),
                        );
                      },
                      child: Text('Zdrowie'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent, // Kolor tła przycisku
                        foregroundColor: Colors.white, // Kolor tekstu
                        textStyle: TextStyle(
                          fontSize: 24, // Zwiększony rozmiar czcionki
                          fontWeight: FontWeight.bold, // Pogrubienie tekstu
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Zaokrąglone rogi
                        ),
                        elevation: 5, // Cieniowanie
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CoachMainScreen()),
                        );
                      },
                      child: Text('Trenerzy'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
