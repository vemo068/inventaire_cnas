import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/page/affectation/add_service_page.dart';


class AgentsPage extends StatelessWidget {
  final AffectationController controller = Get.find<AffectationController>();

   AgentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: Obx(() => ListView.builder(
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final agent = controller.services[index];
              return ListTile(
                title: Text(agent.name),
               
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteAgent(agent.id!),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => AddAgentPage()),
      ),
    );
  }
}
