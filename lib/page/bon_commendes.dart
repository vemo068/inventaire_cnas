import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/bon_de_commende_table.dart';
import 'package:inventaire_cnas/page/add_bon_de_commende.dart';

class BonCommendesPage extends StatelessWidget {
  const BonCommendesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const AddBonDeCommandePage());
        },
        label: const Text("Ajouter Bon de Commende"),
        icon: const Icon(Icons.receipt),
      ),
      appBar: AppBar(
        title: const Text('List des Bon de Commendes'),
      ),
      body: Column(
        children: [
          const Expanded(
              flex: 1,
              child: SizedBox(
                width: 100,
              )),
          Expanded(flex: 9, child: BonDeCommandeTable()),
          // Add a list of Bon de Commendes here
        ],
      ),
    );
  }
}
