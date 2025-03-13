import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/affectation_unit.dart';
import 'package:inventaire_cnas/models/bon_affectation.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddAffectationUnitPage extends StatefulWidget {
  final BonAffectation bonAffectation;
  const AddAffectationUnitPage({super.key, required this.bonAffectation});

  @override
  _AddAffectationUnitPageState createState() => _AddAffectationUnitPageState();
}

class _AddAffectationUnitPageState extends State<AddAffectationUnitPage> {
  final AffectationController affectationController = Get.find<AffectationController>();
  final DatabaseController dbController = Get.find<DatabaseController>();
  Article? selectedArticle;
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter une Unité d'Affectation")),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildAffectationInfoBox(),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildAffectationUnitList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffectationInfoBox() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Service: ${affectationController.services.firstWhere((s) => s.id == widget.bonAffectation.service_id).name}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Date: ${widget.bonAffectation.dateAffectation.toIso8601String().split('T')[0]}"),
            const SizedBox(height: 20),
            const Text("Ajouter une Unité d'Affectation",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildArticleDropdown(),
            const SizedBox(height: 10),
            _buildQuantityInput(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (selectedArticle != null && quantityController.text.isNotEmpty) {
                  affectationController.addAffectationUnit(
                    AffectationUnit(
                      bonAffectationId: widget.bonAffectation.id!,
                      articleId: selectedArticle!.id!,
                      quantity: int.parse(quantityController.text),
                    ),
                  );
                  quantityController.clear();
                  setState(() {});
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleDropdown() {
    return GetBuilder<DatabaseController>(
      builder: (controller) {
        return DropdownSearch<Article>(
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: const InputDecoration(labelText: "Rechercher un article"),
            ),
          ),
          items: controller.articles,
          itemAsString: (Article article) => article.articleName,
          onChanged: (value) {
            setState(() {
              selectedArticle = value;
            });
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: const InputDecoration(
              labelText: "Article",
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityInput() {
    return TextField(
      controller: quantityController,
      decoration: const InputDecoration(labelText: "Quantité", border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildAffectationUnitList() {
    return Obx(() => ListView.builder(
          itemCount: affectationController.affectationUnits.length,
          itemBuilder: (context, index) {
            final unit = affectationController.affectationUnits[index];
            final articleName = dbController.articles.firstWhereOrNull((a) => a.id == unit.articleId)?.articleName ?? "N/A";
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Text("Article: $articleName"),
                subtitle: Text("Quantité: ${unit.quantity}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    affectationController.deleteAffectationUnit(unit.id!);
                  },
                ),
              ),
            );
          },
        ));
  }
}
