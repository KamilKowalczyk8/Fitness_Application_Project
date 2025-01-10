class Trening {
  final int? id;
  final String name;
  final String description;
  final String date;

  Trening({
    this.id,
    required this.name,
    required this.description,
    required this.date,
  });

  factory Trening.fromMap(Map<String, dynamic> map) {
    return Trening(
      id: map['id'],
      name: map['name'] ?? 'Brak nazwy',
      description: map['description'] ?? 'Brak opisu',
      date: map['date'] ?? '0000-00-00',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date,
    };
  }
}
