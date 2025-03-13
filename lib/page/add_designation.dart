import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/textfield_pc.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';

class AddDesignationPage extends StatefulWidget {
  const AddDesignationPage({super.key});

  @override
  _AddDesignationPageState createState() => _AddDesignationPageState();
}

class _AddDesignationPageState extends State<AddDesignationPage> {
  final DatabaseController databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Designation'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "New Designation",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                TxtFldPC(
                  autofocus: true,
                  hint: "Designation Name",
                  controller: databaseController.designationNameController,
                ),
                const SizedBox(height: 16.0),
                TxtFldPC(
                  autofocus: true,
                  hint: "Designation Compte",
                  controller: databaseController.designationCompteController,
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () async {
                      await databaseController.addDesignation();
                      Get.back();
                    },
                    child: const Text('Add Designation'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
