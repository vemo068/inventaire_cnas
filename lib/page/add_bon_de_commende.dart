
import 'package:flutter/material.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';

class AddBonDeCommendePage extends StatefulWidget {
  @override
  _AddBonDeCommendePageState createState() => _AddBonDeCommendePageState();
}

class _AddBonDeCommendePageState extends State<AddBonDeCommendePage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _dateController = TextEditingController();
  final _fournisseurIdController = TextEditingController();
  final _dateBonDeCommendeController = TextEditingController();
  final _montantTotalController = TextEditingController();
  Fournisseur? _selectedFournisseur;
  List<Fournisseur> _fournisseurs = []; // This should be populated with actual data

  @override
  void dispose() {
    _idController.dispose();
    _dateController.dispose();
    _fournisseurIdController.dispose();
    _dateBonDeCommendeController.dispose();
    _montantTotalController.dispose();
    super.dispose();
  }

  void _saveBonDeCommende() {
    if (_formKey.currentState!.validate()) {
      final bonDeCommende = BonDeCommende(
        id: int.parse(_idController.text),
        date: _dateController.text,
        fournisseur_id: _selectedFournisseur!.id.toString(),
        dateBonDeCommende: DateTime.parse(_dateBonDeCommendeController.text),
        montantTotal: double.tryParse(_montantTotalController.text),
      );
      // Save bonDeCommende to database or perform other actions
    }
  }

  void _addCommende() {
    // Logic to add a single commende
  }

  void _finishAddingCommendes() {
    // Logic to finish adding commendes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bon De Commende'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Fournisseur>(
                value: _selectedFournisseur,
                decoration: InputDecoration(labelText: 'Fournisseur'),
                items: _fournisseurs.map((fournisseur) {
                  return DropdownMenuItem<Fournisseur>(
                    value: fournisseur,
                    child: Text(fournisseur.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFournisseur = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a fournisseur';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateBonDeCommendeController,
                decoration: InputDecoration(labelText: 'Date Bon De Commende'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date bon de commende';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _montantTotalController,
                decoration: InputDecoration(labelText: 'Montant Total'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCommende,
                child: Text('Add Commende'),
              ),
              ElevatedButton(
                onPressed: _finishAddingCommendes,
                child: Text('Finish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}