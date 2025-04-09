class BonAffectation {
  int? id;
  int service_id;
  String numeroBonAffectation; // Initialize with an empty string
  DateTime dateAffectation; // Store as DateTime

  BonAffectation({
    this.id,
    required this.numeroBonAffectation,
    required this.service_id,
    required this.dateAffectation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': service_id,
      'numeroBonAffectation': numeroBonAffectation,
      'dateAffectation': dateAffectation
          .toIso8601String()
          .split('T')[0], // Store as String (YYYY-MM-DD)
    };
  }

  static BonAffectation fromJson(Map<String, dynamic> map) {
    return BonAffectation(
      id: map['id'],
      service_id: map['service_id'],
      numeroBonAffectation: map['numeroBonAffectation'], // Default to empty string

      dateAffectation:
          DateTime.parse(map['dateAffectation']), // Convert String to DateTime
    );
  }
}
