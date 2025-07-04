class BonDeCommende {
  int? id;
  String date;
  int fournisseur_id;
  DateTime dateBonDeCommende;
  String numuroBonDeCommende;
  double? montantTotal;

  BonDeCommende({
    this.id,
    required this.numuroBonDeCommende,
    required this.date,
    required this.fournisseur_id,
    required this.dateBonDeCommende,
    this.montantTotal,
  });

  factory BonDeCommende.fromJson(Map<String, dynamic> json) {
    return BonDeCommende(
      id: json['id'],
      numuroBonDeCommende: json['numuroBonDeCommende'],
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
      'numuroBonDeCommende': numuroBonDeCommende,
      'fournisseur_id': fournisseur_id,
      'dateBonDeCommende': dateBonDeCommende.toIso8601String().split('T')[0],
      'montantTotal': montantTotal,
    };
  }
}


// create add_bon_de_commende_page
