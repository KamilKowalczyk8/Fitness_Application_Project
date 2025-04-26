class Dependent {
  final int? id;
  final String name;
  final String ageOrDob;
  final String status;
  final String levelOrGoal;
  final String contact;

  Dependent({
    this.id,
    required this.name,
    required this.ageOrDob,
    required this.status,
    required this.levelOrGoal,
    required this.contact,
  });

  factory Dependent.fromMap(Map<String, dynamic> map) {
    return Dependent(
      id: map['id'],
      name: map['name'],
      ageOrDob: map['ageOrDob'],
      status: map['status'],
      levelOrGoal: map['levelOrGoal'],
      contact: map['contact'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ageOrDob': ageOrDob,
      'status': status,
      'levelOrGoal': levelOrGoal,
      'contact': contact,
    };
  }
}
