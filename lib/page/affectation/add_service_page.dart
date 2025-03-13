import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/models/agent.dart';

class AddAgentPage extends StatelessWidget {
  final AffectationController controller = Get.find<AffectationController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  int? selectedServiceId;

  AddAgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  controller.addAgent(ServiceC(
                    name: nameController.text,
                  ));
                  Get.back();
                }
              },
              child: const Text('Add Service'),
            ),
          ],
        ),
      ),
    );
  }
}
