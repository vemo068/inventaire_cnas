import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/page/articles_page.dart';
import 'package:inventaire_cnas/page/bon_commendes.dart';
import 'package:inventaire_cnas/page/journal.dart';
import 'package:inventaire_cnas/page/list_fournisseurs.dart';
import 'package:inventaire_cnas/page/affectation/nav_affectation.dart';
import 'package:inventaire_cnas/page/add_designation.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final DatabaseController dbController = Get.find();
  final AffectationController affectationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: _buildDashboard(context)),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blueGrey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildSidebarButton(context, Icons.article, "Articles",
              () => Get.to(() => const ArticlesPage())),
          _buildSidebarButton(context, Icons.design_services, "Designations",
              () => Get.to(() => const AddDesignationPage())),
          _buildSidebarButton(context, Icons.groups, "Fournisseurs",
              () => Get.to(() => ListFournisseursPage())),
          _buildSidebarButton(context, Icons.insert_chart_outlined_rounded,
              "Bons de Commande", () => Get.to(() => const BonCommendesPage())),
          _buildSidebarButton(context, Icons.assignment, "Affectations",
              () => Get.to(() => const AffectationsNavigationPage())),
          _buildSidebarButton(context, Icons.newspaper, "Journal du stock",
              () => Get.to(() => const JournalDuStockPage())),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.blueGrey[700],
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GetBuilder<DatabaseController>(
        builder: (dbController) {
          return GridView.extent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildDashboardCard(context, Icons.inventory, "Total Articles",
                  dbController.articles.length.toString()),
              _buildDashboardCard(context, Icons.business, "Total Fournisseurs",
                  dbController.fournisseurs.length.toString()),
              _buildDashboardCard(context, Icons.assignment, "Bons de Commande",
                  dbController.bonDeCommendes.length.toString()),
              GetBuilder<AffectationController>(
                builder: (affectationController) {
                  return _buildDashboardCard(
                    context,
                    Icons.check_circle,
                    "Bon Sorties",
                    affectationController.bonAffectations.length.toString(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, IconData icon, String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
