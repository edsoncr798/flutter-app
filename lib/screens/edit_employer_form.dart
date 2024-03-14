import 'package:flutter/material.dart';
import '../models/employer.dart';
import '../services/employer_service.dart';

class EditEmployerForm extends StatefulWidget {
  final Employer employer;
  static String id = 'edit_employer_form';

  const EditEmployerForm({super.key, required this.employer});

  @override
  State<EditEmployerForm> createState() => _EditEmployerFormState();
}

class _EditEmployerFormState extends State<EditEmployerForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _postController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employer.name);
    _lastnameController = TextEditingController(text: widget.employer.lastname);
    _emailController = TextEditingController(text: widget.employer.email);
    _phoneController = TextEditingController(text: widget.employer.phone);
    _postController = TextEditingController(text: widget.employer.post);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Empleado'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              readOnly: true,
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un numero de teléfono';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _postController,
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
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Guardar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              EmployerService().updateEmployer(
                widget.employer.uid,
                _nameController.text,
                _lastnameController.text,
                _emailController.text,
                _phoneController.text,
                _postController.text,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}