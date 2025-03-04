import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/page/affectation/add_service_page.dart';


class ServicesPage extends StatelessWidget {
  final AffectationController controller = Get.find<AffectationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Services')),
      body: Obx(() => ListView.builder(
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return ListTile(
                title: Text(service.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteService(service.id!),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.to(() => AddServicePage()),
      ),
    );
  }
}
