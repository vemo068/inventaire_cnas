import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';

class AddBonDeCommandePage extends StatefulWidget {
  const AddBonDeCommandePage({super.key});

  @override
  State<AddBonDeCommandePage> createState() => _AddBonDeCommandePageState();
}

class _AddBonDeCommandePageState extends State<AddBonDeCommandePage> {
  final DatabaseController databaseController = Get.find<DatabaseController>();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Bon de Commande'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Nouveau Bon de Commande',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Fournisseur Dropdown
                DropdownButtonFormField<Fournisseur>(
                  decoration: const InputDecoration(
                    labelText: 'Choisir un Fournisseur',
                    border: OutlineInputBorder(),
                  ),
                  value: databaseController.selectedFournisseur,
                  onChanged: (Fournisseur? newFournisseur) {
                    setState(() {
                      databaseController.selectedFournisseur = newFournisseur;
                    });
                  },
                  items: databaseController.fournisseurs
                      .map((fournisseur) => DropdownMenuItem<Fournisseur>(
                            value: fournisseur,
                            child: Text(fournisseur.name),
                          ))
                      .toList(),
                ),

                const SizedBox(height: 16),

                // Numéro Bon
                TextFormField(
                  controller: databaseController.numuroBonDeCommendeController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de Bon de Commande',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // Date Picker
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date de Commande',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(selectedDate),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Créer Bon de Commande'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    if (databaseController.selectedFournisseur != null &&
                        databaseController
                            .numuroBonDeCommendeController.text.isNotEmpty) {
                      databaseController.addBonDeCommende(selectedDate);
                      Get.back();
                    } else {
                      Get.snackbar(
                          "Erreur", "Veuillez remplir tous les champs.",
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
