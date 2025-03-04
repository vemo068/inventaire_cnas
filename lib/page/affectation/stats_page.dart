import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/designation.dart';


class StatistiquesPage extends StatelessWidget {
  final AffectationController controller = Get.find<AffectationController>();
  final DatabaseController dbController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistiques')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('General Statistics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Divider(),
                      Obx(() => ListTile(
                            leading: Icon(Icons.business, color: Colors.blue),
                            title: Text('Total Services'),
                            trailing: Text('${controller.services.length}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          )),
                      Obx(() => ListTile(
                            leading: Icon(Icons.person, color: Colors.green),
                            title: Text('Total Agents'),
                            trailing: Text('${controller.agents.length}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          )),
                      Obx(() => ListTile(
                            leading: Icon(Icons.assignment, color: Colors.red),
                            title: Text('Total Affectations'),
                            trailing: Text('${controller.affectations.length}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Affectations per Service', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Divider(),
                      Expanded(
                        child: Obx(() => ListView.builder(
                              itemCount: controller.services.length,
                              itemBuilder: (context, index) {
                                final service = controller.services[index];
                                final serviceName = dbController.allDesignations.firstWhere(
                                  (s) => s.id == service.id,
                                  orElse: () => Designation(name: 'Unknown'),
                                ).name;
                                final count = controller.affectations.where((aff) =>
                                    controller.agents.any((agent) => agent.service_id == service.id && agent.id == aff.agent_id)).length;
                                return ListTile(
                                  leading: Icon(Icons.work, color: Colors.orangeAccent),
                                  title: Text(serviceName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  trailing: Text('$count Affectations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
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
