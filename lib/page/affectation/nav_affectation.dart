import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/page/affectation/stats_page.dart';
import 'services_page.dart';
import 'affectations_page.dart';

class AffectationsNavigationPage extends StatelessWidget {
  const AffectationsNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Affectations Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: _buildMainContent(context)),
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
          _buildSidebarButton(context, Icons.people, "Agents",
              () => Get.to(() => AgentsPage())),
          _buildSidebarButton(context, Icons.assignment, "Affectations",
              () => Get.to(() => const AffectationsPage())),
          _buildSidebarButton(context, Icons.bar_chart, "Statistiques",
              () => Get.to(() => StatistiquesPage())),
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

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bienvenue sur la plateforme d'affectation",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildDashboardCard(
                    context, Icons.people, "Total Agents", "--"),
                _buildDashboardCard(
                    context, Icons.business, "Total Services", "--"),
                _buildDashboardCard(
                    context, Icons.assignment, "Total Affectations", "--"),
                _buildDashboardCard(
                    context, Icons.bar_chart, "Statistiques", "Voir Détails"),
              ],
            ),
          ),
        ],
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
