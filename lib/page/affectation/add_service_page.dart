import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/models/agent.dart';
import 'package:inventaire_cnas/models/gestion.dart';

class AddAgentPage extends StatefulWidget {
  const AddAgentPage({super.key});

  @override
  State<AddAgentPage> createState() => _AddAgentPageState();
}

class _AddAgentPageState extends State<AddAgentPage> {
  final AffectationController controller = Get.find<AffectationController>();

  final TextEditingController nameController = TextEditingController();

  Gestion? selectedGestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter Service')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Nouveau Service',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                GetBuilder<AffectationController>(
                  builder: (controller) {
                    final gestions = controller.gestions;
                    return DropdownButtonFormField<Gestion>(
                      decoration: const InputDecoration(
                        labelText: 'Sélectionner la Gestion',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedGestion,
                      items: gestions.map((g) {
                        return DropdownMenuItem<Gestion>(
                          value: g,
                          child: Text(g.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGestion = value;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        selectedGestion != null) {
                      controller.addAgent(ServiceC(
                          name: nameController.text,
                          gestion_id: selectedGestion!.id!));
                      Get.back();
                    } else {
                      Get.snackbar("Erreur", "Tous les champs sont requis",
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
