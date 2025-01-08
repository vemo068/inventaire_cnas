//create a table to display the articles
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/article.dart';

class ArticlesTable extends StatelessWidget {
 final DatabaseController databaseController=Get.find<DatabaseController>();
  final Function(Article) onDelete;

  ArticlesTable({ required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Obx(
       () {
        return DataTable(
          columns: [
            DataColumn(label: Text('Designation')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Price HT')),
            DataColumn(label: Text('Montant HT')),
            DataColumn(label: Text('TVA')),
            DataColumn(label: Text('Montant TTC')),
            DataColumn(label: Text('Actions')),
          ],
          rows: databaseController.articles
              .map((article) => DataRow(cells: [
                    DataCell(Text(article.designationName)),
                    DataCell(Text(article.description)),
                    DataCell(Text(article.quantity.toString())),
                    DataCell(Text(article.priceHT.toString())),
                    DataCell(Text(article.montantHT.toString())),
                    DataCell(Text(article.tva.toString())),
                    DataCell(Text(article.montantTTC.toString())),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => onDelete(article),
                    )),
                  ]))
              .toList(),
        );
      }
    );
  }
}