import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';

class CSVBondeCommande {
  static Future<void> generateCSV(DatabaseController dbController) async {
    // Ensure a Bon de Commande is selected
    if (dbController.selectedBonDeCommende == null) {
      print("No Bon de Commande selected.");
      return;
    }

    // Get the selected Bon de Commande details
    final bonDeCommende = dbController.selectedBonDeCommende!;
    final fournisseur = dbController.fournisseurs.firstWhere(
      (f) => f.id == bonDeCommende.fournisseur_id,
      orElse: () => throw Exception("Fournisseur not found"),
    );

    // Header Section with styling
    List<List<dynamic>> data = [
      ["BON DE COMMANDE"],
      ["========================================"],
      ["Fournisseur:", fournisseur.name.toUpperCase()],
      [
        "Date:",
        bonDeCommende.dateBonDeCommende.toIso8601String().split("T")[0]
      ],
      ["Montant Total:", "${bonDeCommende.montantTotal ?? 0} DA"],
      ["========================================"],
      [
        "Article Name",
        "Quantity",
        "Price HT (DA)",
        "TVA (%)",
        "Montant TTC (DA)"
      ]
    ];

    // Filter articles linked to the selected Bon de Commende
    final commandes = dbController.commendes
        .where((c) => c.bonDeCommende_id == bonDeCommende.id)
        .toList();

    double totalMontantTTC = 0.0;

    for (var commande in commandes) {
      final article = dbController.articles.firstWhere(
        (a) => a.id == commande.article_id,
        orElse: () => throw Exception("Article not found"),
      );

      double montantTTC =
          article.priceHT * (1 + article.tva / 100) * commande.quantite;
      totalMontantTTC += montantTTC;

      data.add([
        article.articleName.toUpperCase(),
        commande.quantite,
        "${article.priceHT.toStringAsFixed(2)} DA",
        "${article.tva.toStringAsFixed(2)}%",
        "${montantTTC.toStringAsFixed(2)} DA",
      ]);
    }

    // Add Total Row
    data.add(["========================================"]);
    data.add(
        ["", "", "", "TOTAL:", "${totalMontantTTC.toStringAsFixed(2)} DA"]);
    data.add(["========================================"]);

    // Generate CSV string
    String csvData = const ListToCsvConverter(
      fieldDelimiter: ";", // Use semicolon for Excel compatibility
      eol: "\n", // Ensure correct line endings
      textDelimiter: '"', // Wrap text fields in quotes
    ).convert(data);

    // Define file path in Documents folder
    final directory =
        Directory("C:/Users/${Platform.environment['USERNAME']}/Documents");
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Generate file name
    String formattedDate =
        "${bonDeCommende.dateBonDeCommende.day}-${bonDeCommende.dateBonDeCommende.month}-${bonDeCommende.dateBonDeCommende.year}";
    final file = File(
        "${directory.path}/bon_de_commande_${fournisseur.name}_$formattedDate.csv");

    // Save CSV file
    await file.writeAsString(csvData,
        mode: FileMode.write, flush: true, encoding: utf8);
    print("CSV file saved: ${file.path}");
  }
}
