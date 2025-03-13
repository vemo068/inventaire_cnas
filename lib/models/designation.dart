
class Designation {
  int? id;
  String name;
  String compte;

  Designation({
    this.id,
    required this.name,
    required this.compte,
  });

  // Converts a Designation instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'compte': compte,
      };

  // Creates a Designation instance from a JSON object.
  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json['id'],
        name: json['name'],
        compte: json['compte'],
      );
}
