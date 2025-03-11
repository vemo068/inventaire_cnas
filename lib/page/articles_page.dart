import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/articles_table.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'package:inventaire_cnas/page/add_article.dart';
import 'package:inventaire_cnas/page/add_designation.dart';
import 'package:inventaire_cnas/pdf/csv_stock.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  DatabaseController databaseController = Get.find<DatabaseController>();
  Designation? selectedLocalDesignation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await CSVStock.generateCSV(databaseController);
              Get.snackbar("Success", "CSV file generated in Documents folder",
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Filters",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          TextField(
                            onChanged: (value) =>
                                databaseController.filterArticles(),
                            controller:
                                databaseController.articleSearchController,
                            decoration: const InputDecoration(
                              labelText: "Search Article",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<Designation>(
                            value: selectedLocalDesignation,
                            decoration: const InputDecoration(
                              labelText: "Filter by Category",
                              border: OutlineInputBorder(),
                            ),
                            items: databaseController.designations
                                    .map((designation) {
                                  return DropdownMenuItem<Designation>(
                                    value: designation,
                                    child: Text(designation.name),
                                  );
                                }).toList() +
                                [
                                  const DropdownMenuItem<Designation>(
                                    value: null,
                                    child: Text("All"),
                                  )
                                ],
                            onChanged: (Designation? newValue) {
                              setState(() {
                                selectedLocalDesignation = newValue;
                                databaseController.selectedDesignation =
                                    newValue;
                                databaseController
                                    .filterArticlesByDesignation();
                                databaseController.update();
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () => Get.to(() => AddDesignationPage()),
                            icon: const Icon(Icons.category),
                            label: const Text("Add Category"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(() => const AddArticlePage()),
                    icon: const Icon(Icons.add),
                    label: const Text("Add Article"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 5,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Articles List",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Expanded(child: ArticlesTable()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
