import 'package:get/get.dart';
import 'package:inventaire_cnas/SQL/db_designation.dart';
import 'package:inventaire_cnas/models/affectation_unit.dart';
import 'package:inventaire_cnas/models/bon_affectation.dart';
import 'package:inventaire_cnas/models/agent.dart';

class AffectationController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  var bonAffectations = <BonAffectation>[].obs;
  var affectationUnits = <AffectationUnit>[].obs;
  var allAffectationUnits = <AffectationUnit>[].obs;
  BonAffectation? selectedBonAffectation;
  var services = <ServiceC>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBonAffectations();

    fetchServices();
  }

  // Affectations Management
  Future<void> fetchBonAffectations() async {
    bonAffectations.value = await _dbHelper.getAffectations();
    update();
  }

  Future<void> addBonAffectation(BonAffectation affectation) async {
    await _dbHelper.insertAffectation(affectation);
    fetchBonAffectations();
  }

  Future<void> deleteBonAffectation(int id) async {
    await _dbHelper.deleteAffectation(id);
    fetchBonAffectations();
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

  void updateBonAffectation(BonAffectation bonAffectation) {}

  void fetchAffectationUnitsByBonId(int bonAffectationId) async {
    affectationUnits.value =
        await _dbHelper.getAffectationUnitsByBonId(bonAffectationId);
    update();
  }

  void addAffectationUnit(AffectationUnit unit) async {
    await _dbHelper.insertAffectationUnit(unit);
    fetchAffectationUnitsByBonId(unit.bonAffectationId);
  }

  void deleteAffectationUnit(int id) async {
    await _dbHelper.deleteAffectationUnit(id);
    affectationUnits.removeWhere((unit) => unit.id == id);
  }

  fetchAffectationUnits() async {
    allAffectationUnits.value = await _dbHelper.getAffectationUnits();
    update();
  }
}
