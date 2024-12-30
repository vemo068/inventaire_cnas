import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/page/add_article.dart';

class HomePage extends StatelessWidget {
  final DatabaseController controller = Get.find<DatabaseController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Designations and Articles"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.designations.isEmpty) {
                return const Center(child: Text("No designations found."));
              }
              return ListView.builder(
                itemCount: controller.designations.length,
                itemBuilder: (context, index) {
                  final designation = controller.designations[index];
                  return ListTile(
                    title: Text(designation.name),
                    subtitle: Text("ID: ${designation.id}"),
                    onTap: () => _showArticles(context, designation.name),
                  );
                },
              );
            }),
          ),
          ElevatedButton(
            onPressed: () => _navigateToAddArticle(context),
            child: const Text("Add New Article"),
          ),
        ],
      ),
    );
  }

  // Show articles related to a designation
  void _showArticles(BuildContext context, String designationName) {
    Get.defaultDialog(
      title: "Articles for $designationName",
      content: Obx(() {
        final articles = controller.articles
            .where((article) => article.designationName == designationName)
            .toList();
        if (articles.isEmpty) {
          return const Text("No articles found.");
        }
        return Column(
          children: articles
              .map(
                (article) => ListTile(
                  title: Text(article.description),
                  subtitle: Text(
                      "Quantity: ${article.quantity}, Price HT: ${article.priceHT}"),
                ),
              )
              .toList(),
        );
      }),
    );
  }

  // Navigate to Add Article Page
  void _navigateToAddArticle(BuildContext context) {
    Get.to(() => AddArticlePage());
  }
}
