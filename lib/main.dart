import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:inventaire_cnas/page/home_page.dart';

void main() {
  runApp(const InventaireCnasApp());
}

class InventaireCnasApp extends StatelessWidget {
  const InventaireCnasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
