import 'exercise.model.dart';

class Trening {
  String title;
  String description;
  DateTime date;
  List<Exercise> exercises;

  Trening({
    required this.title,
    required this.description,
    required this.date,
    this.exercises = const [],
  });

  // Konwersja obiektu Trening na Map (dla bazy danych)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  // Tworzenie obiektu Trening z Map (dla pobierania z bazy)
  factory Trening.fromMap(Map<String, dynamic> map) {
    return Trening(
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      exercises: List<Exercise>.from(map['exercises'].map((e) => Exercise.fromMap(e))),
    );
  }
}
