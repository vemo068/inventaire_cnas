class AgentC {
  int? id;
  String name;
  int service_id;


  AgentC({this.id, required this.name, required this.service_id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'service_id': service_id,
    };
  }

  factory AgentC.fromJson(Map<String, dynamic> map) {
    return AgentC(
      id: map['id'],
      name: map['name'],
      service_id: map['service_id'],
    );
  }
}
