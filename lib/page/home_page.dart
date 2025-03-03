import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/articles_table.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/page/add_article.dart';
import 'package:inventaire_cnas/page/add_bon_de_commende.dart';
import 'package:inventaire_cnas/page/add_designation.dart';
import 'package:inventaire_cnas/page/add_fournisseur.dart';
import 'package:inventaire_cnas/page/articles_page.dart';
import 'package:inventaire_cnas/page/bon_commendes.dart';
import 'package:inventaire_cnas/page/list_fournisseurs.dart';

class HomePage extends StatelessWidget {
  DatabaseController controller = Get.find<DatabaseController>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.extent(
          // crossAxisCount: 6,
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildNavigationButton(
              context,
              icon: Icons.article,
              label: "Articles",
              onPressed: () {
                Get.to(() => ArticlesPage());
              },
            ),
            _buildNavigationButton(
              context,
              icon: Icons.design_services,
              label: "Add Designation",
              onPressed: () => Get.to(() => AddDesignationPage()),
            ),
            _buildNavigationButton(
              context,
              icon: Icons.groups,
              label: "Liste des Fournisseurs",
              onPressed: () async {
                Get.to(() => ListFournisseursPage());
              },
            ),
            _buildNavigationButton(
              context,
              icon: Icons.insert_chart_outlined_rounded,
              label: "List des bon de commende",
              onPressed: () async {
                Get.to(() => const BonCommendesPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.0),
          const SizedBox(height: 8.0),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
//               if (controller.designations.isEmpty) {
//                 return const Center(child: Text("No designations found."));
//               }
//               return ListView.builder(
//                 itemCount: controller.designations.length,
//                 itemBuilder: (context, index) {
//                   final designation = controller.designations[index];
//                   return ListTile(
//                     title: Text(designation.name),
//                     subtitle: Text("ID: ${designation.id}"),
//                     onTap: () => _showArticles(context, designation.name),
//                   );
//                 },
//               );
//             }),
//           ),
//           ElevatedButton(
//             onPressed: () => _navigateToAddArticle(context),
//             child: const Text("Add New Article"),
//           ),
//         ],
//       ),
//     );
//   }

//   // Show articles related to a designation
//   void _showArticles(BuildContext context, String designationName) {
//     Get.defaultDialog(
//       title: "Articles for $designationName",
//       content: Obx(() {
//         final articles = controller.articles
//             .where((article) => article.designationName == designationName)
//             .toList();
//         if (articles.isEmpty) {
//           return const Text("No articles found.");
//         }
//         return Column(
//           children: articles
//               .map(
//                 (article) => ListTile(
//                   title: Text(article.description),
//                   subtitle: Text(
//                       "Quantity: ${article.quantity}, Price HT: ${article.priceHT}"),
//                 ),
//               )
//               .toList(),
//         );
//       }),