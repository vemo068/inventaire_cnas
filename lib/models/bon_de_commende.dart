import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';

class BonDeCommende {
  int id;
  String date;
  Fournisseur fournisseur;
  DateTime dateBonDeCommende;
  double? montantTotal;

  BonDeCommende({
    required this.id,
    required this.date,
    required this.fournisseur,
    required this.dateBonDeCommende,
    this.montantTotal,
  });

  factory BonDeCommende.fromJson(Map<String, dynamic> json) {
    return BonDeCommende(
      id: json['id'],
      date: json['date'],
      fournisseur: Fournisseur.fromJson(json['fournisseur']),
      dateBonDeCommende: DateTime.parse(json['dateBonDeCommende']),
      montantTotal: json['montantTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'fournisseur': fournisseur.toJson(),
      'dateBonDeCommende': dateBonDeCommende.toIso8601String(),
      'montantTotal': montantTotal,
    };
  }
}
