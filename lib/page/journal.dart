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
  final TextEditingController designationSearchController =
      TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await affectationController.fetchAffectationUnits();
    dbController.fetchArticles();
    dbController.fetchCommendes();
    dbController.fetchBonDeCommendes();
    affectationController.fetchBonAffectations();
    dbController.fetchAllDesignations();
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
          TextField(
            controller: articleSearchController,
            decoration: const InputDecoration(
                labelText: "Article", border: OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: designationSearchController,
            decoration: const InputDecoration(
                labelText: "Désignation Compte", border: OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
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
              if (picked != null) setState(() => startDate = picked);
            },
            child: Text(startDate != null
                ? DateFormat('dd-MM-yyyy').format(startDate!)
                : 'Sélectionner'),
          ),
          const SizedBox(height: 16),
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
              if (picked != null) setState(() => endDate = picked);
            },
            child: Text(endDate != null
                ? DateFormat('dd-MM-yyyy').format(endDate!)
                : 'Sélectionner'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                articleSearchController.clear();
                designationSearchController.clear();
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

  Widget _buildDataTable() {
    return FutureBuilder(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Obx(() {
          movements.clear();

          for (var commande in dbController.commendes) {
            var bon = dbController.bonDeCommendes
                .firstWhereOrNull((b) => b.id == commande.bonDeCommende_id);
            movements.add({
              "article": dbController.articles
                  .firstWhereOrNull((a) => a.id == commande.article_id),
              "type": "Entré",
              "quantity": commande.quantite,
              "date": bon?.date ?? "N/A"
            });
          }

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

          if (articleSearchController.text.isNotEmpty) {
            movements = movements.where((m) {
              Article? article = m["article"];
              return article != null &&
                  article.articleName
                      .toLowerCase()
                      .contains(articleSearchController.text.toLowerCase());
            }).toList();
          }
          if (designationSearchController.text.isNotEmpty) {
            movements = movements.where((m) {
              Article? article = m["article"];
              final designation = dbController
                  .getDesignationCompteByid(article?.designation_id ?? -1)
                  .toLowerCase();
              return designation
                  .contains(designationSearchController.text.toLowerCase());
            }).toList();
          }
          if (startDate != null) {
            movements = movements.where((m) {
              try {
                DateTime mDate = DateTime.parse(m["date"]);
                return mDate.isAfter(startDate!) ||
                    mDate.isAtSameMomentAs(startDate!);
              } catch (_) {
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
              } catch (_) {
                return false;
              }
            }).toList();
          }

          movements.sort((a, b) => a["date"].compareTo(b["date"]));

          List<DataRow> rows = movements.map((movement) {
            Article? article = movement["article"];
            if (article == null) return const DataRow(cells: []);
            return DataRow(cells: [
              DataCell(Text(article.articleName)),
              DataCell(Text(dbController
                  .getDesignationCompteByid(article.designation_id))),
              DataCell(Text(movement["type"],
                  style: TextStyle(
                    color:
                        movement["type"] == "Entré" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ))),
              DataCell(Text("${movement["quantity"]}")),
              DataCell(Text(movement["date"])),
            ]);
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 16.0,
              columns: const [
                DataColumn(label: Text("Article")),
                DataColumn(label: Text("Compte")),
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
