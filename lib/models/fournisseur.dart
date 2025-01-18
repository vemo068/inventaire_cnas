class Fournisseur {
   int? id;
  String name;

  Fournisseur({
     this.id,
    required this.name,
  });

  // Converts a Designation instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  // Creates a Designation instance from a JSON object.
  factory Fournisseur.fromJson(Map<String, dynamic> json) => Fournisseur(
        id: json['id'],
        name: json['name'],
      );
}