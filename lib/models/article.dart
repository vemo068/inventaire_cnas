class Article {
  int? id;
  int designation_id;
  String articleName;
  String description;
  int quantity;
  double priceHT;
  double montantHT;
  double tva;
  double montantTTC;

  Article({
    this.id,
    required this.articleName,
    required this.designation_id,
    required this.description,
    required this.quantity,
    required this.priceHT,
    this.montantHT = 0.0,
    required this.tva,
    this.montantTTC = 0.0,
  });

  // Converts an Article instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'articleName': articleName ?? '',
        'designation_id': designation_id,
        'description': description,
        'quantity': quantity,
        'priceHT': priceHT,
        'tva': tva,
      };

  // Creates an Article instance from a JSON object.
  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'],
        articleName: json['articleName'],
        designation_id: json['designation_id'],
        description: json['description'],
        quantity: json['quantity'],
        priceHT: json['priceHT'],
        tva: json['tva'],
      );

  
}


// create add article page designed for pc



