
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/designation.dart';


class StatistiquesPage extends StatelessWidget {
  final AffectationController controller = Get.find<AffectationController>();
  final DatabaseController dbController = Get.find<DatabaseController>();

   StatistiquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('General Statistics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Divider(),
                      Obx(() => ListTile(
                            leading: const Icon(Icons.business, color: Colors.blue),
                            title: const Text('Total Services'),
                            trailing: Text('${controller.services.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          )),
                      Obx(() => ListTile(
                            leading: const Icon(Icons.person, color: Colors.green),
                            title: const Text('Total services'),
                            trailing: Text('${controller.services.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          )),
                      Obx(() => ListTile(
                            leading: const Icon(Icons.assignment, color: Colors.red),
                            title: const Text('Total Affectations'),
                            trailing: Text('${controller.bonAffectations.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Affectations per Service', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Divider(),
                      Expanded(
                        child: Obx(() => ListView.builder(
                              itemCount: controller.services.length,
                              itemBuilder: (context, index) {
                                final service = controller.services[index];
                                final serviceName = dbController.allDesignations.firstWhere(
                                  (s) => s.id == service.id,
                                  orElse: () => Designation(name: 'Unknown', compte: ''),
                                ).name;
                                // final count = controller.affectations.where((aff) =>
                                //     controller.services.any((Service) => service.service_id == service.id && agent.id == aff.agent_id)).length;
                                final count = controller.bonAffectations.where((aff) => aff.service_id == service.id).length;
                                return ListTile(
                                  leading: const Icon(Icons.work, color: Colors.orangeAccent),
                                  title: Text(serviceName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  trailing: Text('$count Affectations', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
