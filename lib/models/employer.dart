import 'package:flutter/material.dart';
import 'package:todo_users/services/employer_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/edit_employer_form.dart';
import '../screens/employer_detail_screen.dart';

class Employer {
  final String uid;
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final String post;

  Employer({
    required this.uid,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.post,
  });

  factory Employer.fromDocument(Map<String, dynamic> doc, String id) {
    return Employer(
      uid: id,
      name: doc['name'] ?? '',
      lastname: doc['lastname'] ?? '',
      email: doc['email'] ?? '',
      phone: doc['phone'] ?? '',
      post: doc['post'] ?? '',
    );
  }
}

class EmployerCard extends StatelessWidget {
  const EmployerCard({super.key, required this.employer});
  final Employer employer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          // Aquí puedes ajustar el avatar predeterminado o el icono según tus necesidades
          child: Icon(Icons.person),
        ),
        title: Text('${employer.name} ${employer.lastname}'),
        subtitle: Text(employer.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.message, color: Colors.green),
              onPressed: () async {
                // Lógica para abrir WhatsApp
                String url = 'https://wa.me/${employer.phone}';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo abrir WhatsApp'),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Lógica para editar el empleado
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditEmployerForm(employer: employer);
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar Empleado'),
                      content: Text(
                          '¿Estás seguro de que quieres eliminar a ${employer.name} ${employer.lastname}?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Eliminar'),
                          onPressed: () {
                            EmployerService().deleteEmployer(employer.uid);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        onTap: () {
          if (employer.uid.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EmployerDetailsScreen(employerId: employer.uid),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: El ID del empleado está vacío'),
              ),
            );
          }
        },
      ),
    );
  }
}
