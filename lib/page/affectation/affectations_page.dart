import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/agent.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'add_affectation_page.dart';

class AffectationsPage extends StatefulWidget {
  const AffectationsPage({super.key});

  @override
  _AffectationsPageState createState() => _AffectationsPageState();
}

class _AffectationsPageState extends State<AffectationsPage> {
  final AffectationController controller = Get.find<AffectationController>();
  final DatabaseController dbController = Get.find<DatabaseController>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Affectations')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Search by Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                              dateController.text =
                                  pickedDate.toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startDateController,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              startDate = pickedDate;
                              startDateController.text =
                                  pickedDate.toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              endDate = pickedDate;
                              endDateController.text =
                                  pickedDate.toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Agent')),
                  DataColumn(label: Text('Article')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: controller.affectations.where((affectation) {
                  if (selectedDate != null) {
                    return affectation.dateAffectation
                            .toString()
                            .split(' ')[0] ==
                        selectedDate.toString().split(' ')[0];
                  }
                  if (startDate != null && endDate != null) {
                    DateTime affectationDate =
                        DateTime.parse(affectation.dateAffectation.toString());
                    return affectationDate.isAfter(startDate!) &&
                        affectationDate.isBefore(endDate!);
                  }
                  return true;
                }).map((affectation) {
                  final agentName = controller.agents
                      .firstWhere(
                        (agent) => agent.id == affectation.agent_id,
                      )
                      .name;
                  final articleName = dbController.allArticles
                      .firstWhere(
                        (article) => article.id == affectation.article_id,
                      )
                      .articleName;
                  return DataRow(cells: [
                    DataCell(Text(agentName)),
                    DataCell(Text(articleName)),
                    DataCell(Text(
                        affectation.dateAffectation.toString().split('T')[0])),
                    DataCell(IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          controller.deleteAffectation(affectation.id!),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => const AddAffectationPage()),
      ),
    );
  }
}
