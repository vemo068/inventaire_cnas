import 'package:get/get.dart';
import 'package:inventaire_cnas/SQL/db_designation.dart';
import 'package:inventaire_cnas/models/affectation.dart';
import 'package:inventaire_cnas/models/agent.dart';
import 'package:inventaire_cnas/models/service.dart';

class AffectationController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  var affectations = <Affectation>[].obs;
  var agents = <AgentC>[].obs;
  var services = <ServiceC>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAffectations();
    fetchAgents();
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
  Future<void> fetchAgents() async {
    agents.value = await _dbHelper.getAgents();
    update();
  }

  Future<void> addAgent(AgentC agent) async {
    await _dbHelper.insertAgent(agent);
    fetchAgents();
  }

  Future<void> updateAgent(AgentC agent) async {
    await _dbHelper.updateAgent(agent);
    fetchAgents();
  }

  Future<void> deleteAgent(int id) async {
    await _dbHelper.deleteAgent(id);
    fetchAgents();
  }

  // Services Management
  Future<void> fetchServices() async {
    services.value = await _dbHelper.getServices();
    update();
  }

  Future<void> addService(ServiceC service) async {
    await _dbHelper.insertService(service);
    fetchServices();
  }

  Future<void> updateService(ServiceC service) async {
    await _dbHelper.updateService(service);
    fetchServices();
  }

  Future<void> deleteService(int id) async {
    await _dbHelper.deleteService(id);
    fetchServices();
  }
}
