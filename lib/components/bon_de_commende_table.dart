import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';

class BonDeCommandeTable extends StatelessWidget {
  final DatabaseController databaseController = Get.find<DatabaseController>();

  BonDeCommandeTable({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DatabaseController>(
      builder: (controller) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Fournisseur')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Actions')),
              ],
              rows: controller.bonDeCommendes
                  .map((commande) => DataRow(cells: [
                        DataCell(Text(commande.date.toString())),
                        DataCell(Text(commande.fournisseur_id.toString())),
                        DataCell(Text(commande.montantTotal.toString())),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                        )),
                      ]))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
