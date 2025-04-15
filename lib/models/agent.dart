class ServiceC {
  int? id;
  String name;
  int gestion_id;

  ServiceC({
    this.id,
    required this.name,
    required this.gestion_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gestion_id': gestion_id,
    };
  }

  factory ServiceC.fromJson(Map<String, dynamic> map) {
    return ServiceC(
      id: map['id'],
      name: map['name'],
      gestion_id: map['gestion_id'],
    );
  }
}
