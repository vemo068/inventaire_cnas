import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/articles_table.dart';
import 'package:inventaire_cnas/components/textfield_pc.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/page/add_article.dart';
import 'package:inventaire_cnas/page/add_designation.dart';

class ArticlesPage extends StatelessWidget {
  DatabaseController databaseController = Get.find<DatabaseController>();
  ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles Page"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildNavigationButton(
                  context,
                  icon: Icons.add,
                  label: "Add Article",
                  onPressed: () => Get.to(() => AddArticlePage()),
                ),
              ),
              Expanded(
                child: _buildNavigationButton(
                  context,
                  icon: Icons.design_services,
                  label: "Add Designation",
                  onPressed: () => Get.to(() => AddDesignationPage()),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      databaseController.filterArticles();
                    },
                    controller: databaseController.articleSearchController,
                    decoration: const InputDecoration(
                      labelText: "Recherche",
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: DropdownButton<String>(
                value: databaseController.selectedValue,
                items: const [
                  DropdownMenuItem(
                    value: "data1",
                    child: Text("data1"),
                  ),
                  DropdownMenuItem(
                    value: "data2",
                    child: Text("data2"),
                  ),
                  DropdownMenuItem(
                    value: "data3",
                    child: Text("data3"),
                  ),
                  DropdownMenuItem(
                    value: "data4",
                    child: Text("data4"),
                  ),
                ],
                onChanged: (String? newValue) {
                  databaseController.selectedValue = newValue;
                  databaseController.update();
                },
              )),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
              flex: 10,
              child:
                  Container(color: Colors.grey[200], child: ArticlesTable())),
        ],
      ),
    );
  }
}

Widget _buildNavigationButton(BuildContext context,
    {required IconData icon,
    required String label,
    required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(16.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20.0),
        const SizedBox(height: 8.0),
        Text(label, textAlign: TextAlign.center),
      ],
    ),
  );
}
