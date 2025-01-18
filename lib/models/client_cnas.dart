class ClientCnas {
  int? id;
  String name;

  ClientCnas({
    this.id,
    required this.name,
  });

  // Converts a Designation instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  // Creates a Designation instance from a JSON object.
  factory ClientCnas.fromJson(Map<String, dynamic> json) => ClientCnas(
        id: json['id'],
        name: json['name'],
      );
}
