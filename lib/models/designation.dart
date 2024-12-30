class Designation {
  int? id;
  String name;

  Designation({
     this.id,
    required this.name,
  });

  // Converts a Designation instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  // Creates a Designation instance from a JSON object.
  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json['id'],
        name: json['name'],
      );
}
