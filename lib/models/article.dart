class Article {
  int? id;
  String designationName;
  String description;
  int quantity;
  double priceHT;
  double montantHT;
  double tva;
  double montantTTC;

  Article({
     this.id,
    required this.designationName,
    required this.description,
    required this.quantity,
    required this.priceHT,
    required this.montantHT,
    required this.tva,
    required this.montantTTC,
  });

  // Converts an Article instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'designationName': designationName,
        'description': description,
        'quantity': quantity,
        'priceHT': priceHT,
        'montantHT': montantHT,
        'tva': tva,
        'montantTTC': montantTTC,
      };

  // Creates an Article instance from a JSON object.
  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'],
        designationName: json['designationName'],
        description: json['description'],
        quantity: json['quantity'],
        priceHT: json['priceHT'],
        montantHT: json['montantHT'],
        tva: json['tva'],
        montantTTC: json['montantTTC'],
      );
}
