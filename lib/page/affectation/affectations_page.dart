import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/models/bon_affectation.dart';
import 'package:inventaire_cnas/page/affectation/add_affectation_page.dart';
import 'package:inventaire_cnas/page/affectation/edit_affectation.dart';
import 'package:inventaire_cnas/page/affectation/add_affectation_unit.dart';

class AffectationsPage extends StatelessWidget {
  const AffectationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AffectationController affectationController =
        Get.find<AffectationController>();
    final DatabaseController databaseController =
        Get.find<DatabaseController>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const AddAffectationPage());
        },
        label: const Text("Ajouter Bon d'Affectation"),
        icon: const Icon(Icons.assignment),
      ),
      appBar: AppBar(
        title: const Text("Liste des Bons d'Affectation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => DataTable(
                  columnSpacing: 16.0,
                  columns: const [
                    DataColumn(label: Text("Service")),
                    DataColumn(label: Text("Date Affectation")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: affectationController.bonAffectations.map((bon) {
                    final service = affectationController.services
                            .firstWhereOrNull((s) => s.id == bon.service_id)
                            ?.name ??
                        "N/A";
                    return DataRow(cells: [
                      DataCell(Text(service)),
                      DataCell(Text(
                          bon.dateAffectation.toIso8601String().split('T')[0])),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.add_box, color: Colors.green),
                            onPressed: () {
                              affectationController
                                  .fetchAffectationUnitsByBonId(bon.id!);
                              Get.to(() =>
                                  AddAffectationUnitPage(bonAffectation: bon));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Get.to(() =>
                                  EditAffectationPage(bonAffectation: bon));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              affectationController
                                  .deleteBonAffectation(bon.id!);
                            },
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                )),
          ),
        ),
      ),
    );
  }
}
