class AffectationUnit {
  int? id;
  int bonAffectationId;
  int articleId;
  int quantity;

  AffectationUnit({
    this.id,
    required this.bonAffectationId,
    required this.articleId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'affectation_id': bonAffectationId,
      'article_id': articleId,
      'quantity': quantity,
    };
  }

  factory AffectationUnit.fromJson(Map<String, dynamic> map) {
    return AffectationUnit(
      id: map['id'],
      bonAffectationId: map['affectation_id'],
      articleId: map['article_id'],
      quantity: map['quantity'],
    );
  }
}
