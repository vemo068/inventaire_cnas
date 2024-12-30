import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/article.dart';

class AddArticlePage extends StatelessWidget {
  final DatabaseController controller = Get.find<DatabaseController>();
  final _formKey = GlobalKey<FormState>();

  String? selectedDesignation;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceHTController = TextEditingController();
  final TextEditingController tvaController = TextEditingController();

  AddArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Article"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                if (controller.designations.isEmpty) {
                  return const Text("No designations available.");
                }
                return DropdownButtonFormField<String>(
                  value: selectedDesignation,
                  items: controller.designations
                      .map((designation) => DropdownMenuItem<String>(
                            value: designation.name,
                            child: Text(designation.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedDesignation = value;
                  },
                  decoration: const InputDecoration(
                    labelText: "Select Designation",
                  ),
                  validator: (value) =>
                      value == null ? "Please select a designation" : null,
                );
              }),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a description" : null,
              ),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a quantity" : null,
              ),
              TextFormField(
                controller: priceHTController,
                decoration: const InputDecoration(labelText: "Price HT"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a price" : null,
              ),
              TextFormField(
                controller: tvaController,
                decoration: const InputDecoration(labelText: "TVA (%)"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter the TVA" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addArticle,
                child: const Text("Add Article"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addArticle() {
    if (_formKey.currentState!.validate()) {
      final article = Article(
        id: 0, // Auto-incremented
        designationName: selectedDesignation!,
        description: descriptionController.text,
        quantity: int.parse(quantityController.text),
        priceHT: double.parse(priceHTController.text),
        montantHT: double.parse(priceHTController.text) *
            int.parse(quantityController.text),
        tva: double.parse(tvaController.text),
        montantTTC: double.parse(priceHTController.text) *
            int.parse(quantityController.text) *
            (1 + double.parse(tvaController.text) / 100),
      );

      controller.addArticle(article);
      Get.back(); // Return to the previous page
    }
  }
}
