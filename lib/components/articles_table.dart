//create a table to display the articles
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';

class ArticlesTable extends StatelessWidget {
  final DatabaseController databaseController = Get.find<DatabaseController>();

  ArticlesTable({super.key});

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
                DataColumn(label: Text('Designation')),
                DataColumn(label: Text('Article')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Price HT')),
                DataColumn(label: Text('Montant HT')),
                DataColumn(label: Text('TVA')),
                DataColumn(label: Text('Montant TTC')),
                DataColumn(label: Text('Actions')),
              ],
              rows: controller.articles
                  .map((article) => DataRow(cells: [
                        DataCell(Text(controller
                            .getDesignationNameByid(article.designation_id))),
                        DataCell(Text(article.articleName ?? '')),
                        DataCell(Text(article.description)),
                        DataCell(Text(article.quantity.toString())),
                        DataCell(Text(article.priceHT.toString())),
                        DataCell(Text(
                            (article.priceHT * article.quantity).toString())),
                        DataCell(Text(article.tva.toString())),
                        DataCell(
                          Text(
                            (
                              (article.priceHT * article.quantity) *
                                  (article.tva / 100 + 1),
                            ).toString(),
                          ),
                        ),
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
