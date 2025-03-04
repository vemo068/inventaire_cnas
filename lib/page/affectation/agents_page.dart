import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/page/affectation/add_agent_page.dart';


class AgentsPage extends StatelessWidget {
  final AffectationController controller = Get.find<AffectationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agents')),
      body: Obx(() => ListView.builder(
            itemCount: controller.agents.length,
            itemBuilder: (context, index) {
              final agent = controller.agents[index];
              return ListTile(
                title: Text(agent.name),
                subtitle: Text(agent.post),
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
