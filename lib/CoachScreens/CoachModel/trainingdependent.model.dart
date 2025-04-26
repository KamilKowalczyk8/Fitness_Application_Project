class TrainingDependent {
  final int? id;
  final int dependentId;
  final String name;
  final int duration;

  TrainingDependent({
    this.id,
    required this.dependentId,
    required this.name,
    required this.duration,
  });

  factory TrainingDependent.fromMap(Map<String, dynamic> map) {
    return TrainingDependent(
      id: map['id'],
      dependentId: map['dependentId'],
      name: map['name'],
      duration: map['duration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dependentId': dependentId,
      'name': name,
      'duration': duration,
    };
  }
}
