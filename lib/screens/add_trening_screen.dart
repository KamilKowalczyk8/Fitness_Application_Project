import 'package:flutter/material.dart';

class AddTreningScreen extends StatefulWidget {
  @override
  _AddTreningScreenState createState() => _AddTreningScreenState();
}

class _AddTreningScreenState extends State<AddTreningScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj Trening'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Tytuł Treningu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać tytuł';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Opis'),
                maxLines: 3,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context, {'title': _title, 'description': _description});
                    }
                  },
                  child: Text('Dodaj Trening'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
