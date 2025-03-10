class Affectation {
  int? id;
  int service_id;
  int article_id;
  DateTime dateAffectation; // Store as DateTime

  Affectation({
    this.id,
    required this.service_id,
    required this.article_id,
    required this.dateAffectation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agent_id': service_id,
      'article_id': article_id,
      'dateAffectation': dateAffectation.toIso8601String().split('T')[0], // Store as String (YYYY-MM-DD)
    };
  }

  static Affectation fromJson(Map<String, dynamic> map) {
    return Affectation(
      id: map['id'],
      service_id: map['service_id'],
      article_id: map['article_id'],
      dateAffectation: DateTime.parse(map['dateAffectation']), // Convert String to DateTime
    );
  }
}
