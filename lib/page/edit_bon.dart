import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/components/commendes.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';

class BuyPage extends StatelessWidget {
  BuyPage({Key? key}) : super(key: key);
  final DatabaseController databaseController = Get.find<DatabaseController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kcbackground,
      appBar: AppBar(
        title: Text("Bon de Commende Page"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          BonDeCommendeInfoBox(),
          SizedBox(height: 20),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                // SellOrders(),
                Commendes(),
          )),
          AddCommendeButton()
        ],
      ),
    );
  }
}

class AddCommendeButton extends StatelessWidget {
  AddCommendeButton({Key? key}) : super(key: key);
  final DatabaseController databaseController = Get.find<DatabaseController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              //  Get.to(() => AddCommendePage());
            },
            child: Text("Add Commende"),
          ),
        ],
      ),
    );
  }
}


class BonDeCommendeInfoBox extends StatelessWidget {
  BonDeCommendeInfoBox({Key? key}) : super(key: key);
  final DatabaseController databaseController = Get.find<DatabaseController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                databaseController.selectedFournisseur!.name,
               // style: mediHeading3Style.copyWith(color: kcwhite
                ),
              ),
              Expanded(
                child: Text(databaseController.selectedBonDeCommende!.date.toString(),
                 //   style: mediHeading3Style.copyWith(color: kcwhite
                    )),
              
            ],
          ),
          SizedBox(height: 20),
          GetBuilder(
              init: databaseController,
              builder: (_) {
                return Text(
                    "${(databaseController.selectedBonDeCommende!.montantTotal)} DA",
                 //   style: mediHeading2Style.copyWith(color: kcaccent)
                    );
              }),
        ],
      ),
    );
  }
}
