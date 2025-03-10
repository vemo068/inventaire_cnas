import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/page/affectation/add_service_page.dart';


class AgentsPage extends StatelessWidget {
  final AffectationController controller = Get.find<AffectationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Services')),
      body: Obx(() => ListView.builder(
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final agent = controller.services[index];
              return ListTile(
                title: Text(agent.name),
               
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteAgent(agent.id!),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.to(() => AddAgentPage()),
      ),
    );
  }
}
