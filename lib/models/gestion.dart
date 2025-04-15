// const String gestionTable = '''
//   CREATE TABLE gestion (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     name TEXT NOT NULL
//   )''';

class Gestion {
  int? id;
  String name;

  //fromjson and to json functions 

  Gestion({this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
  factory Gestion.fromJson(Map<String, dynamic> map) {
    return Gestion(
      id: map['id'],
      name: map['name'],
    );
  }
}
