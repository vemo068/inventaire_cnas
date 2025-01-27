import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/commendes.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/designation.dart';

class EditBonCommendePage extends StatelessWidget {
  EditBonCommendePage({super.key});
  final DatabaseController databaseController = Get.find<DatabaseController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kcbackground,
      appBar: AppBar(
        title: const Text("Bon de Commende Page"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          const BonDeCommendeInfoBox(),
          const SizedBox(height: 20),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                // SellOrders(),
                Commendes(),
          )),
          // AddCommendeButton()
        ],
      ),
    );
  }
}

class AddCommendeButton extends StatelessWidget {
  AddCommendeButton({super.key});
  final DatabaseController databaseController = Get.find<DatabaseController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              //  Get.to(() => AddCommendePage());
            },
            child: const Text("Add Commende"),
          ),
        ],
      ),
    );
  }
}

class BonDeCommendeInfoBox extends StatefulWidget {
  const BonDeCommendeInfoBox({super.key});

  @override
  State<BonDeCommendeInfoBox> createState() => _BonDeCommendeInfoBoxState();
}

class _BonDeCommendeInfoBoxState extends State<BonDeCommendeInfoBox> {
  final DatabaseController databaseController = Get.find<DatabaseController>();
  Designation? selectedLocalDesignation;
  Article? selectedLocalArticle;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  (databaseController.selectedBonDeCommende!.fournisseur_id)
                      .toString(),
                  // style: mediHeading3Style.copyWith(color: kcwhite
                ),
              ),
              Expanded(
                  child: Text(
                databaseController.selectedBonDeCommende!.date.toString(),
                //   style: mediHeading3Style.copyWith(color: kcwhite
              )),
              GetBuilder(
                  init: databaseController,
                  builder: (_) {
                    return Text(
                      "TOTAL : "
                      "${(databaseController.selectedBonDeCommende!.montantTotal)} DA",
                      //   style: mediHeading2Style.copyWith(color: kcaccent)
                    );
                  }),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Ajouter une Commende"),
          Row(
            children: [
              GetBuilder<DatabaseController>(
                builder: (_) {
                  if (databaseController.designations.isEmpty) {
                    return const Text('No designations available');
                  } else {
                    return SizedBox(
                        height: 50,
                        child: DropdownButton<Designation>(
                          value: selectedLocalDesignation,
                          items: databaseController.allDesignations
                              .map((designation) {
                            return DropdownMenuItem<Designation>(
                              value: designation,
                              child: Text(designation.name),
                            );
                          }).toList(),
                          onChanged: (Designation? newValue) {
                            setState(() {
                              selectedLocalDesignation = newValue;
                              databaseController
                                  .selectedDesignationForCommende = newValue;

                              databaseController.update();
                            });
                          },
                        ));
                  }
                },
              ),
              const SizedBox(
                width: 16,
              ),
              GetBuilder<DatabaseController>(
                builder: (_) {
                  if (databaseController.articles.isEmpty) {
                    return const Text('No articles available');
                  } else {
                    return SizedBox(
                        height: 50,
                        child: DropdownButton<Article>(
                          value: selectedLocalArticle,
                          items: selectedLocalDesignation == null
                              ? []
                              : databaseController.allArticles
                                  .where((article) =>
                                      article.designation_id ==
                                      selectedLocalDesignation!.id)
                                  .map((article) {
                                  return DropdownMenuItem<Article>(
                                    value: article,
                                    child: Text(article.articleName),
                                  );
                                }).toList(),
                          onChanged: (Article? newValue) {
                            setState(() {
                              selectedLocalArticle = newValue;
                              databaseController.selectedArticleForCommende =
                                  newValue;

                              databaseController.update();
                            });
                          },
                        ));
                  }
                },
              ),
              const SizedBox(
                width: 16,
              ),
              GetBuilder<DatabaseController>(
                builder: (_) {
                  return SizedBox(
                    width: 100,
                    child: TextField(
                      controller:
                          databaseController.quantityControllerForCommende,
                      decoration: const InputDecoration(
                        hintText: "Quantity",
                      ),
                    ),
                  );
                },
              ),

              // SizedBox(height: 16.0),

              //button
              ElevatedButton(
                onPressed: () {
                  databaseController.addCommende();
                  // Get.back();
                },
                child: const Text('Add Commende'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
