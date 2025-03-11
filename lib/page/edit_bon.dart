import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/commendes.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'package:inventaire_cnas/pdf/bon_commende.dart';
import 'package:inventaire_cnas/pdf/csv_bon_de_commende.dart';

class EditBonCommendePage extends StatelessWidget {
  EditBonCommendePage({super.key});
  final DatabaseController databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bon de Commande"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
  icon: const Icon(Icons.download),
  onPressed: () async {
    await CSVBondeCommande.generateCSV(databaseController);
    Get.snackbar("Succès", "CSV généré dans Documents", snackPosition: SnackPosition.BOTTOM);
  },
),

          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final file = await BonDeCommandePDF.generate(databaseController);
              Get.snackbar("Succès", "PDF généré: ${file.path}",
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildCommandeInfoBox(),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Commendes(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandeInfoBox() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Fournisseur: ${databaseController.fournisseurs.firstWhere((f) => f.id == databaseController.selectedBonDeCommende?.fournisseur_id).name ?? 'N/A'}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
                "Date: ${databaseController.selectedBonDeCommende?.date ?? 'N/A'}"),
            Text(
                "Total: ${databaseController.selectedBonDeCommende?.montantTotal ?? 0} DA",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            const SizedBox(height: 20),
            const Text("Ajouter une Commande",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildCategoryDropdown(),
            const SizedBox(height: 10),
            _buildArticleDropdown(),
            const SizedBox(height: 10),
            _buildQuantityInput(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => databaseController.addCommende(),
              child: const Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return GetBuilder<DatabaseController>(
      builder: (controller) {
        return DropdownButtonFormField<Designation>(
          decoration: const InputDecoration(
              labelText: "Catégorie", border: OutlineInputBorder()),
          items: controller.designations.map((designation) {
            return DropdownMenuItem(
                value: designation, child: Text(designation.name));
          }).toList(),
          onChanged: (value) {
            controller.selectedDesignationForCommende = value;
            controller.update();
          },
        );
      },
    );
  }

  Widget _buildArticleDropdown() {
    return GetBuilder<DatabaseController>(
      builder: (controller) {
        return DropdownButtonFormField<Article>(
          decoration: const InputDecoration(
              labelText: "Article", border: OutlineInputBorder()),
          items: controller.allArticles
              .where((article) =>
                  article.designation_id ==
                  controller.selectedDesignationForCommende?.id)
              .map((article) {
            return DropdownMenuItem(
                value: article, child: Text(article.articleName));
          }).toList(),
          onChanged: (value) {
            controller.selectedArticleForCommende = value;
            controller.update();
          },
        );
      },
    );
  }

  Widget _buildQuantityInput() {
    return GetBuilder<DatabaseController>(
      builder: (controller) {
        return TextField(
          controller: controller.quantityControllerForCommende,
          decoration: const InputDecoration(
              labelText: "Quantité", border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        );
      },
    );
  }
}
