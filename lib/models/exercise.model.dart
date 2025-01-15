class Exercise {
  final int? id;
  final int trainingId;
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final String weightUnit;

  Exercise({
    this.id,
    required this.trainingId,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.weightUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'training_id': trainingId,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'weight_unit': weightUnit,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      trainingId: map['training_id'],
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      weight: map['weight'],
      weightUnit: map['weight_unit'],
    );
  }
}