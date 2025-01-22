import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/textfield_pc.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';

class AddFournisseurPage extends StatefulWidget {
  const AddFournisseurPage({super.key});

  @override
  _AddFournisseurPageState createState() => _AddFournisseurPageState();
}

class _AddFournisseurPageState extends State<AddFournisseurPage> {
  final DatabaseController databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fournisseur'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TxtFldPC(
                autofocus: true,
                hint: "Fournisseur Name",
                controller: databaseController.fournisseurController,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await databaseController.addFournisseur();
                  Get.back();
                },
                child: const Text('Add Fournisseur'),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
