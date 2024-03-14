import 'package:flutter/material.dart';
import 'package:todo_users/services/employer_service.dart';

class AddEmployerForm extends StatefulWidget {
  const AddEmployerForm({super.key});
  @override
  State<AddEmployerForm> createState() => _AddEmployerFormState();
}

class _AddEmployerFormState extends State<AddEmployerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();

  final EmployerService employerService = EmployerService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar nuevo empleado'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un apellido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un teléfono';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _jobController,
              decoration: const InputDecoration(labelText: 'Cargo'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un cargo';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Guardar'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try{
               await employerService.createEmployer(
                   _nameController.text,
                   _lastnameController.text,
                   _emailController.text,
                   _phoneController.text,
                   _jobController.text
               );
               Navigator.of(context).pop();
              }catch(e){
                throw Exception('Error al crear el empleado: $e');
              }
            }
          },
        ),
      ],
    );
  }
}