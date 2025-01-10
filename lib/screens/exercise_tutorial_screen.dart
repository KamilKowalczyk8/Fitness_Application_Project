import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseTutorialScreen extends StatefulWidget {
  @override
  _ExerciseTutorialScreenState createState() => _ExerciseTutorialScreenState();
}

class _ExerciseTutorialScreenState extends State<ExerciseTutorialScreen> {
  // Lista ćwiczeń z linkami do filmów
  final List<Map<String, String>> exercises = [
    {
      'name': 'Wyciskanie sztangi',
      'videoUrl': 'https://www.youtube.com/watch?v=5zhNzc4DMMw',
    },
    {
      'name': 'Ściąganie drążka wyciągu górnego',
      'videoUrl': 'https://www.youtube.com/watch?v=D7zI8jGWiDI',
    },
    {
      'name': 'Przysiad ze sztangą',
      'videoUrl': 'https://www.youtube.com/watch?v=aX7aE0meWcY',
    },
  ];

  // Zmienna przechowująca aktualnie wybrane ćwiczenie
  String? selectedExercise;

  // Funkcja uruchamiająca link
  Future<void> _launchURL(String videoUrl) async {
    final Uri url = Uri.parse(videoUrl);
    try {
      // Spróbuj uruchomić link z aplikacji zewnętrznej (np. przeglądarki)
      if (await canLaunch(url.toString())) {
        await launch(url.toString(), forceSafariVC: false, forceWebView: false);
      } else {
        throw 'Nie można otworzyć linku: $videoUrl';
      }
    } catch (e) {
      print("Błąd otwierania linku: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Poradnik ćwiczeń')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Rozwijana lista wyboru ćwiczenia
            DropdownButton<String>(
              value: selectedExercise,
              hint: Text('Wybierz ćwiczenie'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedExercise = newValue;
                });
              },
              items: exercises.map<DropdownMenuItem<String>>((exercise) {
                return DropdownMenuItem<String>(
                  value: exercise['name'],
                  child: Text(exercise['name']!),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Przycisk uruchamiający film
            if (selectedExercise != null)
              ElevatedButton(
                onPressed: () {
                  final exercise = exercises.firstWhere(
                          (element) => element['name'] == selectedExercise);
                  _launchURL(exercise['videoUrl']!); // Uruchomienie odpowiedniego filmu
                },
                child: Text('Zobacz film'),
              ),
          ],
        ),
      ),
    );
  }
}
