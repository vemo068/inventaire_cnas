import 'package:get/get.dart';
import 'package:inventaire_cnas/SQL/db_designation.dart';
import 'package:inventaire_cnas/models/affectation.dart';
import 'package:inventaire_cnas/models/agent.dart';

class AffectationController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  var affectations = <Affectation>[].obs;
  var services = <ServiceC>[].obs;
 

  @override
  void onInit() {
    super.onInit();
    fetchAffectations();
    
    fetchServices();
  }

  // Affectations Management
  Future<void> fetchAffectations() async {
    affectations.value = await _dbHelper.getAffectations();
    update();
  }

  Future<void> addAffectation(Affectation affectation) async {
    await _dbHelper.insertAffectation(affectation);
    fetchAffectations();
  }

  Future<void> deleteAffectation(int id) async {
    await _dbHelper.deleteAffectation(id);
    fetchAffectations();
  }

  // Agents Management
  Future<void> fetchServices() async {
    services.value = await _dbHelper.getServices();
    update();
  }

  Future<void> addAgent(ServiceC agent) async {
    await _dbHelper.insertService(agent);
    fetchServices();
  }

  Future<void> updateAgent(ServiceC agent) async {
    await _dbHelper.updateService(agent);
    fetchServices();
  }

  Future<void> deleteAgent(int id) async {
    await _dbHelper.deleteService(id);
    fetchServices();
  }

  
  

}
