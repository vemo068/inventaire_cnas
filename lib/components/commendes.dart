import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/commende.dart';

class Commendes extends StatelessWidget {
  Commendes({super.key});
  final DatabaseController databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DatabaseController>(
      init: databaseController,
      builder: (_) {
        if (databaseController.commendes.isEmpty) {
          return const Center(
            child: Text("No Commendes."),
          );
        } else {
          return ListView.builder(
            itemCount: databaseController.commendes.length,
            itemBuilder: (context, index) {
              return CommendeTile(
                commende: databaseController.commendes[index],
              );
            },
          );
        }
      },
    );
  }
}

class CommendeTile extends StatelessWidget {
  final Commende commende;
  CommendeTile({super.key, required this.commende});
  final DatabaseController databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    Article article = databaseController.allArticles
        .firstWhere((element) => element.id == commende.article_id);
    double total = (article.priceHT * (article.tva / 100)) * commende.quantite;
    return Column(
      children: [
        ListTile(
          onLongPress: () {
            databaseController.selectedCommende = commende;
            Get.defaultDialog(
              backgroundColor: Colors.green[200],
              title: "Supprimer",
              textCancel: "Cancel",
              cancelTextColor: Colors.grey,
              textConfirm: "Confirm",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              middleText: "Are you sure you want to delete this commende?",
              onConfirm: () {
                databaseController.selectedCommende = commende;
                databaseController.deleteCommende();
                //databaseController.updateBonDeCommende(total);
              },
              onCancel: () {
                databaseController.selectedCommende = null;
              },
            );
          },
          title: Text(article.articleName),
          subtitle: Text("${commende.quantite} pcs"),
          trailing: Text("$total DA"),
        ),
        const Divider(),
      ],
    );
  }
}
