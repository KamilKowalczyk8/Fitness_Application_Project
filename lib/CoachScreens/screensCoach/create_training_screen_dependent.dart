import 'package:flutter/material.dart';
import 'package:fitness1945/CoachScreens/CoachModel/dependent.model.dart';
import 'package:fitness1945/CoachScreens/services_coach/training_database_dependent.dart';
import 'package:fitness1945/CoachScreens/CoachModel/trainingdependent.model.dart';

class CreateTrainingScreenDependent extends StatelessWidget {
  final Dependent dependent;

  CreateTrainingScreenDependent({required this.dependent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Treningi dla: ${dependent.name}')),
      body: FutureBuilder<List<TrainingDependent>>(
        future: TrainingDatabaseDependent.instance.getTrainingsForDependent(dependent.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Błąd ładowania danych'));
          }
          final trainings = snapshot.data ?? [];
          return ListView.builder(
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              final training = trainings[index];
              return Card(
                child: ListTile(
                  title: Text(training.name),
                  subtitle: Text('Czas Trwania: ${training.duration} minut'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logika dodawania nowego treningu
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}
