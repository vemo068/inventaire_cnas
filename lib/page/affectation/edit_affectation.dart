import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/bon_affectation.dart';

class EditAffectationPage extends StatefulWidget {
  final BonAffectation bonAffectation;

  const EditAffectationPage({super.key, required this.bonAffectation});

  @override
  _EditAffectationPageState createState() => _EditAffectationPageState();
}

class _EditAffectationPageState extends State<EditAffectationPage> {
  final AffectationController affectationController = Get.find<AffectationController>();
  final DatabaseController dbController = Get.find<DatabaseController>();
  int? selectedServiceId;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedServiceId = widget.bonAffectation.service_id;
    selectedDate = widget.bonAffectation.dateAffectation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier Bon d Affectation')),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Modifier Bon d Affectation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Sélectionner Service', border: OutlineInputBorder()),
                  value: selectedServiceId,
                  items: affectationController.services.map((service) {
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
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Sélectionner Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
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
                    text: selectedDate.toIso8601String().split('T')[0],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    if (selectedServiceId != null) {
                      affectationController.updateBonAffectation(
                        BonAffectation(
                          numeroBonAffectation: widget.bonAffectation.numeroBonAffectation,
                          id: widget.bonAffectation.id,
                          service_id: selectedServiceId!,
                          dateAffectation: selectedDate,
                        ),
                      );
                      Get.back();
                    }
                  },
                  child: const Text('Modifier Bon d Affectation', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
