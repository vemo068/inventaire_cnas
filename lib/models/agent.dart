class ServiceC {
  int? id;
  String name;
  
  

  ServiceC(
      {this.id,
      required this.name,
      });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      
    };
  }

  factory ServiceC.fromJson(Map<String, dynamic> map) {
    return ServiceC(
      id: map['id'],
      name: map['name'],
      
    );
  }
}
