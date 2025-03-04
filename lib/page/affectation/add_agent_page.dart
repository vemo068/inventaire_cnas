import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/models/agent.dart';

class AddAgentPage extends StatelessWidget {
  final AffectationController controller = Get.find<AffectationController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  int? selectedServiceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Agent')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: postController,
              decoration: InputDecoration(labelText: 'Post'),
            ),
            DropdownButtonFormField<int>(
              value: selectedServiceId,
              decoration: InputDecoration(labelText: 'Service'),
              items: controller.services.map((service) {
                return DropdownMenuItem<int>(
                  value: service.id,
                  child: Text(service.name),
                );
              }).toList(),
              onChanged: (value) {
                selectedServiceId = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && postController.text.isNotEmpty && selectedServiceId != null) {
                  controller.addAgent(AgentC(
                    name: nameController.text,
                    post: postController.text,
                    service_id: selectedServiceId!,
                  ));
                  Get.back();
                }
              },
              child: Text('Add Agent'),
            ),
          ],
        ),
      ),
    );
  }
}
