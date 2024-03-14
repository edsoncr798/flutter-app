import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployerDetailsScreen extends StatelessWidget {
  final String employerId;

  const EmployerDetailsScreen({super.key, required this.employerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Empleado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('employers').doc(employerId).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Algo salió mal"),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData || snapshot.data!.data() == null) {
                return const Center(
                  child: Text("Empleado no encontrado"),
                );
              }

              Map<String, dynamic> data = snapshot.data!.data()! as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: data['photoUrl'] != null
                          ? NetworkImage(data['photoUrl'])
                          : const AssetImage('assets/default_avatar.png') as ImageProvider,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text("Nombre: ${data['name']} ${data['lastname']}"),
                  ),
                  ListTile(
                    title: Text("Email: ${data['email']}"),
                  ),
                  ListTile(
                    title: Text("Teléfono: ${data['phone']}"),
                  ),
                  ListTile(
                    title: Text("Cargo: ${data['post']}"),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
