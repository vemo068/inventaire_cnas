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
        List<Commende> thisCommendes = databaseController.commendes
            .where((element) =>
                element.bonDeCommende_id ==
                databaseController.selectedBonDeCommende!.id)
            .toList();

        if (thisCommendes.isEmpty) {
          return const Center(
            child: Text("No Commendes."),
          );
        } else {
          return ListView.builder(
            itemCount: thisCommendes.length,
            itemBuilder: (context, index) {
              return CommendeTile(
                commende: thisCommendes[index],
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
    double total =
        (article.priceHT * (article.tva / 100 + 1)) * commende.quantite;
    return Column(
      children: [
        ListTile(
          onLongPress: () {
            databaseController.selectedCommende = commende;
            // databaseController.selectedArticleToUpdate = article;
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
                databaseController.removeCommende();
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
