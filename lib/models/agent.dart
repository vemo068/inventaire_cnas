class AgentC {
  int? id;
  String name;
  String post;
  int service_id;


  AgentC({this.id, required this.name, required this.service_id, required this.post});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'service_id': service_id,
      'post': post,
    };
  }

  factory AgentC.fromJson(Map<String, dynamic> map) {
    return AgentC(
      id: map['id'],
      name: map['name'],
      service_id: map['service_id'],
      post: map['post'],
    );
  }
}
