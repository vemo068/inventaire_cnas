import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/textfield_pc.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';

// class AddDesignationPage extends StatelessWidget {
//   final DatabaseController databaseController = Get.find<DatabaseController>();
//   AddDesignationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Designation'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               TxtFldPC(
//                 autofocus: true,
//                 hint: "Designation Name",
//                 controller: TextEditingController(),
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () async {
//                   await databaseController.addDesignation();
//                   Get.back();
//                 },
//                 child: Text('Add Designation'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class AddDesignationPage extends StatefulWidget {
  AddDesignationPage({super.key});

  @override
  _AddDesignationPageState createState() => _AddDesignationPageState();
}

class _AddDesignationPageState extends State<AddDesignationPage> {
  final DatabaseController databaseController = Get.find<DatabaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Designation'),
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
                hint: "Designation Name",
                controller: databaseController.designationNameController,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await databaseController.addDesignation();
                  Get.back();
                },
                child: Text('Add Designation'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
