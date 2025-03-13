import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/commende.dart';
import 'package:intl/intl.dart';

class BonDeCommandePDF {
  static Future<File> generate(DatabaseController dbController) async {
    final pdf = pw.Document();

    final BonDeCommende? bon = dbController.selectedBonDeCommende;
    final fournisseur = dbController.fournisseurs
        .firstWhere((a) => a.id == bon!.fournisseur_id);
    final List<Commende> commandes = dbController.commendes
        .where((c) => c.bonDeCommende_id == bon?.id)
        .toList();

    final String formattedDate = bon?.dateBonDeCommende != null
        ? DateFormat('dd-MM-yyyy').format(bon!.dateBonDeCommende)
        : "N/A";
    final String fileName =
        "bon de commande ${fournisseur.name ?? 'N_A'} $formattedDate.pdf";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text("CNAS",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Bon de Commande",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Fournisseur: ${fournisseur.name ?? 'N/A'}"),
              pw.Text("Date: $formattedDate"),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: [
                  "Article",
                  "Quantité",
                  "Prix Unitaire",
                  "TVA",
                  "Montant TTC"
                ],
                data: commandes.map((commende) {
                  final article = dbController.articles.firstWhere(
                    (a) => a.id == commende.article_id,
                    orElse: () => Article(
                        articleName: 'N/A',
                        priceHT: 0,
                        tva: 0,
                        montantTTC: 0,
                        quantity: 0,
                        designation_id: 0,
                        description: ''),
                  );
                  return [
                    article.articleName,
                    commende.quantite.toString(),
                    "${article.priceHT} DA",
                    "${article.tva}%",
                    "${(article.montantTTC) * commende.quantite} DA",
                  ];
                }).toList(),
                border: pw.TableBorder.all(),
                cellAlignment: pw.Alignment.center,
              ),
              pw.SizedBox(height: 20),
              pw.Text("Montant Total: ${bon?.montantTotal ?? 0} DA",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 40),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Text("Signature 1"),
                    pw.SizedBox(height: 40),
                    pw.Container(width: 100, height: 1, color: PdfColors.black),
                  ]),
                  pw.Column(children: [
                    pw.Text("Signature 2"),
                    pw.SizedBox(height: 40),
                    pw.Container(width: 100, height: 1, color: PdfColors.black),
                  ]),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output =
        Directory("C:/Users/${Platform.environment['USERNAME']}/Documents");
    if (!await output.exists()) {
      await output.create(recursive: true);
    }
    final file = File("${output.path}/$fileName");
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
