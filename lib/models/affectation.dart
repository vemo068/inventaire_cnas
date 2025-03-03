class Affectation {
  int? id;
  int agent_id;
  int article_id;
  DateTime dateAffectation;

  Affectation(
      {this.id,
      required this.agent_id,
      required this.article_id,
      required this.dateAffectation});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agent_id': agent_id,
      'article_id': article_id,
      'dateAffectation': dateAffectation,
    };
  }

  static Affectation fromJson(Map<String, dynamic> map) {
    return Affectation(
      id: map['id'],
      agent_id: map['agent_id'],
      article_id: map['article_id'],
      dateAffectation: map['dateAffectation'],
    );
  }
}
