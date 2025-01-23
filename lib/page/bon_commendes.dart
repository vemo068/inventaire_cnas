import 'package:flutter/material.dart';
import 'package:inventaire_cnas/components/bon_de_commende_table.dart';

class BonCommendesPage extends StatelessWidget {
  const BonCommendesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List des Bon de Commendes'),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    // databaseController.addBonDeCommende();
                    // databaseController.update();
                  },
                  child: const Text('Ajoute une bon de commende'),
                ),
              )),
          Expanded(flex: 9, child: BonDeCommandeTable()),
          // Add a list of Bon de Commendes here
        ],
      ),
    );
  }
}
