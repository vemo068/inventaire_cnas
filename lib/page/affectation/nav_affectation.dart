import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/page/affectation/stats_page.dart';
import 'agents_page.dart';
import 'services_page.dart';
import 'affectations_page.dart';

class AffectationsNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavigationButton(title: 'Agents', page: AgentsPage()),
            NavigationButton(title: 'Services', page: ServicesPage()),
            NavigationButton(title: 'Affectations', page: AffectationsPage()),
            NavigationButton(title: 'Statistiques', page: StatistiquesPage()),
          ],
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String title;
  final Widget page;

  NavigationButton({required this.title, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
        onPressed: () => Get.to(() => page),
        child: Text(title, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
