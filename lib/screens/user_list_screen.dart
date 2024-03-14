import 'package:flutter/material.dart';
import 'package:todo_users/models/employer.dart';
import 'package:todo_users/screens/add_employer_form.dart';
import 'package:todo_users/services/employer_service.dart';


class UserListScreen extends StatelessWidget {
  final EmployerService employerService = EmployerService();
  static String id = 'login_screen';

  UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Empleados'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<Employer>>(
        stream: employerService.getAllEmployers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Employer employer = snapshot.data![index];
                return EmployerCard(employer: employer);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context){
              return const AddEmployerForm();
            }
          );
        },
        child: const Icon(Icons.add),
      )
    );
  }
}