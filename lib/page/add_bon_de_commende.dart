import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';
import '../controllers/database_controller.dart';

class AddBonDeCommandePage extends StatelessWidget {
  const AddBonDeCommandePage({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseController = Get.find<DatabaseController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bon de Commande'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Date : ${DateTime.now().toString().substring(0, 10)}'),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 200,
                child: DropdownButton<Fournisseur>(
                  hint: const Text('Choose a fournisseur'),
                  value: databaseController.selectedFournisseur,
                  onChanged: (Fournisseur? newFournisseur) {
                    databaseController.selectedFournisseur = newFournisseur;
                  },
                  items: databaseController.fournisseurs
                      .map<DropdownMenuItem<Fournisseur>>((Fournisseur value) {
                    return DropdownMenuItem<Fournisseur>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  databaseController.addBonDeCommende();
                  databaseController.update();
                  Get.back();
                },
                child: const Text('Ajoute une bon de commende'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
