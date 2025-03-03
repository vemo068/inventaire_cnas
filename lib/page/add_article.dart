import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:inventaire_cnas/components/textfield_pc.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/designation.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final DatabaseController databaseController = Get.find<DatabaseController>();
  var selectedLocalDesignation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Article'),
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
                  if (databaseController.designations.isEmpty) {
                    return const Text('No designations available');
                  } else {
                    return SizedBox(
                        height: 50,
                        child: DropdownButton<Designation>(
                          
                          hint: const Text('Select Category'),
                          value: selectedLocalDesignation,
                          items: databaseController.designations
                              .map((designation) {
                            return DropdownMenuItem<Designation>(
                              value: designation,
                              child: Text(designation.name),
                            );
                          }).toList(),
                          onChanged: (Designation? newValue) {
                            setState(() {
                              selectedLocalDesignation = newValue;
                              databaseController.selectedDesignation = newValue;

                              databaseController.update();
                            });
                          },
                        ));
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TxtFldPC(
                hint: "article nom",
                controller: databaseController.articleNameController,
              ),
              TxtFldPC(
                hint: "description",
                controller: databaseController.descriptionController,
              ),
              const SizedBox(height: 16.0),
              TxtFldPC(
                  hint: "prix HT",
                  controller: databaseController.priceHTController),
              const SizedBox(height: 16.0),
              TxtFldPC(
                  hint: "quantite",
                  controller: databaseController.quantityController),
              const SizedBox(height: 16.0),
              TxtFldPC(
                  hint: "tva", controller: databaseController.tvaController),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  databaseController.addArticle();
                  Get.back();
                },
                child: const Text('Add Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
