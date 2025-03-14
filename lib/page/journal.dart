import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:intl/intl.dart';
import 'package:inventaire_cnas/pdf/journal_csv.dart';

class JournalDuStockPage extends StatefulWidget {
  const JournalDuStockPage({super.key});

  @override
  _JournalDuStockPageState createState() => _JournalDuStockPageState();
}

class _JournalDuStockPageState extends State<JournalDuStockPage> {
  final DatabaseController dbController = Get.find<DatabaseController>();
  final AffectationController affectationController =
      Get.find<AffectationController>();
      List<Map<String, dynamic>> movements = [];

  // Filter variables
  final TextEditingController articleSearchController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch the required data from the controllers
  Future<void> _fetchData() async {
    await affectationController.fetchAffectationUnits();
    dbController.fetchArticles();
    dbController.fetchCommendes();
    dbController.fetchBonDeCommendes();
    await affectationController.fetchBonAffectations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal du Stock"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              // Assuming you have filter variables (searchQuery, startDate, endDate) in your state:
              await JournalCSV().generateCSV(
                movements: movements,
                searchQuery: articleSearchController.text,
                startDate: startDate,
                endDate: endDate,
              );
              Get.snackbar("Succès", "CSV généré dans Documents",
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterPanel(),
          const SizedBox(width: 16),
          Expanded(child: _buildDataTable()),
        ],
      ),
    );
  }

  // Left filter panel
  Widget _buildFilterPanel() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        border: Border.all(color: Colors.blueGrey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filtres",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Article search field
          TextField(
            controller: articleSearchController,
            decoration: const InputDecoration(
                labelText: "Article", border: OutlineInputBorder()),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          // Start Date picker
          const Text("Date de début:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: startDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null)
                setState(() {
                  startDate = picked;
                });
            },
            child: Text(startDate != null
                ? DateFormat('dd-MM-yyyy').format(startDate!)
                : 'Sélectionner'),
          ),
          const SizedBox(height: 16),
          // End Date picker
          const Text("Date de fin:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: endDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null)
                setState(() {
                  endDate = picked;
                });
            },
            child: Text(endDate != null
                ? DateFormat('dd-MM-yyyy').format(endDate!)
                : 'Sélectionner'),
          ),
          const SizedBox(height: 16),
          // Reset filters button
          ElevatedButton(
            onPressed: () {
              setState(() {
                articleSearchController.clear();
                startDate = null;
                endDate = null;
              });
            },
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }

  // Right data table panel
  Widget _buildDataTable() {
    return FutureBuilder(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        return Obx(() {
          

          // Add commande movements (Ajouté)
          for (var commande in dbController.commendes) {
            var bon = dbController.bonDeCommendes
                .firstWhereOrNull((b) => b.id == commande.bonDeCommende_id);
            movements.add({
              "article": dbController.articles
                  .firstWhereOrNull((a) => a.id == commande.article_id),
              "type": "Ajouté",
              "quantity": commande.quantite,
              "date": bon?.date ?? "N/A"
            });
          }

          // Add affectation movements (Sortie)
          for (var affectation in affectationController.allAffectationUnits) {
            var bon = affectationController.bonAffectations
                .firstWhereOrNull((b) => b.id == affectation.bonAffectationId);
            movements.add({
              "article": dbController.articles
                  .firstWhereOrNull((a) => a.id == affectation.articleId),
              "type": "Sortie",
              "quantity": affectation.quantity,
              "date":
                  bon?.dateAffectation.toIso8601String().split('T')[0] ?? "N/A"
            });
          }

          // Apply filters
          if (articleSearchController.text.isNotEmpty) {
            movements = movements.where((m) {
              Article? article = m["article"];
              if (article == null) return false;
              return article.articleName
                  .toLowerCase()
                  .contains(articleSearchController.text.toLowerCase());
            }).toList();
          }
          if (startDate != null) {
            movements = movements.where((m) {
              try {
                DateTime mDate = DateTime.parse(m["date"]);
                return mDate.isAfter(startDate!) ||
                    mDate.isAtSameMomentAs(startDate!);
              } catch (e) {
                return false;
              }
            }).toList();
          }
          if (endDate != null) {
            movements = movements.where((m) {
              try {
                DateTime mDate = DateTime.parse(m["date"]);
                return mDate.isBefore(endDate!) ||
                    mDate.isAtSameMomentAs(endDate!);
              } catch (e) {
                return false;
              }
            }).toList();
          }

          // Sort by date
          movements.sort((a, b) => a["date"].compareTo(b["date"]));

          List<DataRow> rows = [];
          for (var movement in movements) {
            Article? article = movement["article"];
            if (article == null) continue;
            rows.add(DataRow(cells: [
              DataCell(Text(article.articleName)),
              DataCell(
                Text(
                  movement["type"],
                  style: TextStyle(
                    color: movement["type"] == "Ajouté"
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(Text("${movement["quantity"]}")),
              DataCell(Text(movement["date"])),
            ]));
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 16.0,
              columns: const [
                DataColumn(label: Text("Article")),
                DataColumn(label: Text("Mouvement")),
                DataColumn(label: Text("Quantité")),
                DataColumn(label: Text("Date")),
              ],
              rows: rows,
            ),
          );
        });
      },
    );
  }
}
