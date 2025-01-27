import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';

class Commende {
  int? id;
  
  int article_id;
  int quantite;
  int bonDeCommende_id;

  Commende({
    this.id,
   
    required this.article_id,
    required this.quantite,
    required this.bonDeCommende_id,
  });

  // Converts an Article instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
       
        'article_id': article_id,
        'quantite': quantite,
        'bonDeCommende_id': bonDeCommende_id,
      };

  // Creates an Article instance from a JSON object.
  factory Commende.fromJson(Map<String, dynamic> json) => Commende(
        id: json['id'],
        bonDeCommende_id: json['bonDeCommende_id'],
       
        article_id: json['article_id'],
        quantite: json['quantite'],
      );
}

