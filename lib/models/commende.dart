import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';

class Commende {
  String? id;
  
  Article article;
  int quantite;
  BonDeCommende bonDeCommende;

  Commende({
    this.id,
   
    required this.article,
    required this.quantite,
    required this.bonDeCommende,
  });

  // Converts an Article instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
       
        'article': article.toJson(),
        'quantite': quantite,
        'bonDeCommende': bonDeCommende.toJson(),
      };

  // Creates an Article instance from a JSON object.
  factory Commende.fromJson(Map<String, dynamic> json) => Commende(
        id: json['id'],
        bonDeCommende: BonDeCommende.fromJson(json['bonDeCommende']),
       
        article: Article.fromJson(json['article']),
        quantite: json['quantite'],
      );
}

