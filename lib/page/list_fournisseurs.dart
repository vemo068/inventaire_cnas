import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/page/add_fournisseur.dart';

class ListFournisseursPage extends StatelessWidget {
  final DatabaseController _databaseController = Get.find<DatabaseController>();

  ListFournisseursPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Fournisseurs'),
      ),
      body: GetBuilder<DatabaseController>(
        init: _databaseController,
        builder: (_) {
          if (_databaseController.fournisseurs.isEmpty) {
            return Column(
              children: [
                const Expanded(
                  flex: 9,
                  child: Center(
                    child: Text('No fournisseurs found.'),
                  ),
                ),
                AddFournisseurButton(),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    itemCount: _databaseController.fournisseurs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: Colors.grey,
                          title: Text(
                              _databaseController.fournisseurs[index].name),
                        ),
                      );
                    },
                  ),
                ),
                AddFournisseurButton(),
              ],
            );
          }
        },
      ),
    );
  }

  Expanded AddFournisseurButton() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => Get.to(() => const AddFournisseurPage()),
          child: const Text('Ajouter un Fournisseur'),
        ),
      ),
    );
  }
}
