import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitness1945/CoachScreens/CoachModel/dependent.model.dart';
import 'package:fitness1945/CoachScreens/services_coach/dependent_database.dart';

class AddDependentScreen extends StatefulWidget {
  final Dependent? dependent;

  AddDependentScreen({this.dependent});

  @override
  _AddDependentScreenState createState() => _AddDependentScreenState();
}

class _AddDependentScreenState extends State<AddDependentScreen> {
  final TextEditingController _dependentNameController = TextEditingController();
  final TextEditingController _dependentAgeController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    if (widget.dependent != null) {
      _dependentNameController.text = widget.dependent!.name;
      _dependentAgeController.text = widget.dependent!.ageOrDob;
      _selectedStatus = widget.dependent!.status;
      _levelController.text = widget.dependent!.levelOrGoal;
      _contactController.text = widget.dependent!.contact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dependent == null ? 'Dodaj Podopiecznego' : 'Edytuj Podopiecznego'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dependentNameController,
              decoration: InputDecoration(labelText: 'Imię i Nazwisko'),
            ),
            TextField(
              controller: _dependentAgeController,
              decoration: InputDecoration(labelText: 'Data Urodzenia (dd-MM-yyyy)'),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                  setState(() {
                    _dependentAgeController.text = formattedDate;
                  });
                }
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(labelText: 'Status'),
              items: [
                DropdownMenuItem(value: 'aktywny', child: Text('Aktywny')),
                DropdownMenuItem(value: 'nieaktywny', child: Text('Nieaktywny')),
                DropdownMenuItem(value: 'wstrzymany', child: Text('Wstrzymany')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
            TextField(
              controller: _levelController,
              decoration: InputDecoration(labelText: 'Poziom Zaawansowania/Cel Treningowy'),
            ),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Kontakt (numer telefonu, e-mail)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final dependent = Dependent(
                  id: widget.dependent?.id,
                  name: _dependentNameController.text,
                  ageOrDob: _dependentAgeController.text,
                  status: _selectedStatus ?? 'aktywny',
                  levelOrGoal: _levelController.text,
                  contact: _contactController.text,
                );
                if (widget.dependent == null) {
                  await DatabaseService.instance.insertDependent(dependent);
                } else {
                  await DatabaseService.instance.updateDependent(dependent);
                }
                Navigator.pop(context, true); // Zamknij ekran po zapisaniu
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                textStyle: TextStyle(fontSize: 24),
                foregroundColor: Colors.white,
              ),
              child: Text(widget.dependent == null ? 'Dodaj Podopiecznego' : 'Zapisz Zmiany'),
            ),
          ],
        ),
      ),
    );
  }
}
