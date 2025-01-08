import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/textfield_pc.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';

class AddArticlePage extends StatefulWidget {
  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final DatabaseController databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Article'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(() {
                if (databaseController.designations.isEmpty) {
                  return Text('No designations available');
                } else {
                  return DropdownButton<String>(
                    value: databaseController.selectedDesignation?.name,
                    hint: Text('Select Designation'),
                    onChanged: (String? newValue) {
                      setState(() {
                        databaseController.selectedDesignation!.name =
                            newValue!;
                      });
                    },
                    items: databaseController.designations.map((designation) {
                      return DropdownMenuItem<String>(
                        value: databaseController.selectedDesignation!.name,
                        child:
                            Text(databaseController.selectedDesignation!.name),
                      );
                    }).toList(),
                  );
                }
              }),
              SizedBox(height: 16.0),
              Obx(() {
                return ElevatedButton(
                  onPressed: databaseController.designations.isEmpty
                      ? null
                      : () async {
                          await databaseController.addDesignation();
                          Get.back();
                        },
                  child: Text('Add Designation'),
                );
              }),
              TxtFldPC(
                hint: "fff",
                controller: TextEditingController(),
              ),
              SizedBox(height: 16.0),
              TxtFldPC(hint: "hint", controller: TextEditingController()),
              SizedBox(height: 16.0),
              TxtFldPC(hint: "hint", controller: TextEditingController()),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add article logic
                },
                child: Text('Add Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
