import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';

class Commende {
  String? id;
  Fournisseur fournisseur;
  Article article;
  int quantite;


  Commende({
    this.id,
    required this.fournisseur,
    required this.article,
    required this.quantite,
  });

  // Converts an Article instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'fournisseur': fournisseur.toJson(),
        'article': article.toJson(),
        'quantite': quantite,
      };

  // Creates an Article instance from a JSON object.
  factory Commende.fromJson(Map<String, dynamic> json) => Commende(
        id: json['id'],
        fournisseur: Fournisseur.fromJson(json['fournisseur']),
        article: Article.fromJson(json['article']),
        quantite: json['quantite'],
      );

}
