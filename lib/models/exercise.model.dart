class Exercise {
  final int? id;
  final String name;
  final int sets;
  final int reps;
  final int trainingId;

  Exercise({
    this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.trainingId,
  });

  // Konwersja obiektu Exercise na Map (dla bazy danych)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'trening_id': trainingId,
    };
  }

  // Tworzenie obiektu Exercise z Map (dla pobierania z bazy)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      trainingId: map['trening_id'],
    );
  }
}
