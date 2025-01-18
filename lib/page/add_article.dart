import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/textfield_pc.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/designation.dart';

class AddArticlePage extends StatelessWidget {
  final DatabaseController databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Article'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GetBuilder<DatabaseController>(
                builder: (_) {
                  if (databaseController.getDesignationNames().isEmpty) {
                    return Text('No designations available');
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: databaseController.designations
                            .map((Designation value) {
                          return GestureDetector(
                            onTap: () {
                              databaseController.selectedDesignation = value;
                              databaseController.update();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                color: databaseController.selectedDesignation ==
                                        value
                                    ? Colors.blue
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                value.name,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
              TxtFldPC(
                hint: "article nom",
                controller: databaseController.articleNameController,
              ),
              TxtFldPC(
                hint: "description",
                controller: databaseController.descriptionController,
              ),
              SizedBox(height: 16.0),
              TxtFldPC(
                  hint: "prix HT",
                  controller: databaseController.priceHTController),
              SizedBox(height: 16.0),
              TxtFldPC(
                  hint: "quantite",
                  controller: databaseController.quantityController),
              SizedBox(height: 16.0),
              TxtFldPC(
                  hint: "tva", controller: databaseController.tvaController),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  databaseController.addArticle();
                  Get.back();
                },
                child: Text('Add Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
