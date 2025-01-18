class Article {
  int? id;
  String designationName;
  String? articleName;
  String description;
  int quantity;
  double priceHT;
  double montantHT;
  double tva;
  double montantTTC;

  Article({
    this.id,
    required this.articleName,
    required this.designationName,
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
        'designationName': designationName,
        'description': description,
        'quantity': quantity,
        'priceHT': priceHT,
        
        'tva': tva,
        
      };

  // Creates an Article instance from a JSON object.
  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'],
        articleName: json['articleName'],
        designationName: json['designationName'],
        description: json['description'],
        quantity: json['quantity'],
        priceHT: json['priceHT'],
       
        tva: json['tva'],
        
      );
}


// create add article page designed for pc



