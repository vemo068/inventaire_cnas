import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/bon_affectation.dart';

class AddAffectationPage extends StatefulWidget {
  const AddAffectationPage({super.key});

  @override
  _AddAffectationPageState createState() => _AddAffectationPageState();
}

class _AddAffectationPageState extends State<AddAffectationPage> {
  final AffectationController controller = Get.find<AffectationController>();
  final DatabaseController dbController = Get.find<DatabaseController>();
  int? selectedServiceId;
  int? selectedArticleId;
  final TextEditingController numeroBonController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // Default to today

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajoute Bon de sortie')),
      body: Center(
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nouveaux Bon de Sortie',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                      labelText: 'Select Service',
                      border: OutlineInputBorder()),
                  items: controller.services.map((service) {
                    return DropdownMenuItem<int>(
                      value: service.id,
                      child: Text(service.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedServiceId = value;
                    });
                  },
                ), const SizedBox(height: 16),

                TextFormField(
                  controller: numeroBonController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro Bon de Sortie',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: selectedDate != null
                        ? selectedDate.toString().split(' ')[0]
                        : '',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    if (selectedServiceId != null) {
                      controller.addBonAffectation(BonAffectation(
                        numeroBonAffectation: numeroBonController.text,
                        service_id: selectedServiceId!,
                        dateAffectation: selectedDate,
                      ));
                      Get.back();
                    }
                  },
                  child: const Text('Ajoute Bon de Sortie',
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
