import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Designation? selectedDesignation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Article'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "New Article",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                GetBuilder<DatabaseController>(
                  builder: (_) {
                    return DropdownButtonFormField<Designation>(
                      decoration: const InputDecoration(
                          labelText: "Select Category",
                          border: OutlineInputBorder()),
                      value: selectedDesignation,
                      items: databaseController.designations.map((designation) {
                        return DropdownMenuItem<Designation>(
                          value: designation,
                          child: Text(designation.name),
                        );
                      }).toList(),
                      onChanged: (Designation? newValue) {
                        setState(() {
                          selectedDesignation = newValue;
                          databaseController.selectedDesignation = newValue;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                TxtFldPC(
                    hint: "Article Name",
                    controller: databaseController.articleNameController),
                TxtFldPC(
                    hint: "Description",
                    controller: databaseController.descriptionController),
                TxtFldPC(
                    hint: "Price HT",
                    controller: databaseController.priceHTController),
                TxtFldPC(
                    hint: "Quantity",
                    controller: databaseController.quantityController),
                TxtFldPC(
                    hint: "TVA", controller: databaseController.tvaController),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      databaseController.addArticle();
                      Get.back();
                    },
                    child: const Text('Add Article'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
