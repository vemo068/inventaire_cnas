// const String affectationUnitTable = '''
//       CREATE TABLE affectationUnits (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         affectation_id INTEGER NOT NULL,
//         article_id INTEGER NOT NULL,
//         quantity INTEGER NOT NULL,
//         FOREIGN KEY (affectation_id) REFERENCES affectations(id)
//         FOREIGN KEY (article_id) REFERENCES articles(id)
//       )''';


class AffectationUnit {
  int? id;
  int affectationId;
  int articleId;
  int quantity;

  AffectationUnit({
    this.id,
    required this.affectationId,
    required this.articleId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'affectation_id': affectationId,
      'article_id': articleId,
      'quantity': quantity,
    };
  }

  factory AffectationUnit.fromJson(Map<String, dynamic> map) {
    return AffectationUnit(
      id: map['id'],
      affectationId: map['affectation_id'],
      articleId: map['article_id'],
      quantity: map['quantity'],
    );
  } 
  
  
}