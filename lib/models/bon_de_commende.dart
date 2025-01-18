import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';

class BonDeCommende {
  int id;
  String date;
  String fournisseur_id;
  DateTime dateBonDeCommende;
  double? montantTotal;

  BonDeCommende({
    required this.id,
    required this.date,
    required this.fournisseur_id,
    required this.dateBonDeCommende,
    this.montantTotal,
  });

  factory BonDeCommende.fromJson(Map<String, dynamic> json) {
    return BonDeCommende(
      id: json['id'],
      date: json['date'],
      fournisseur_id: json['fournisseur_id'],
      dateBonDeCommende: DateTime.parse(json['dateBonDeCommende']),
      montantTotal: json['montantTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'fournisseur': fournisseur_id,
      'dateBonDeCommende': dateBonDeCommende.toIso8601String(),
      'montantTotal': montantTotal,
    };
  }
  
  
}


