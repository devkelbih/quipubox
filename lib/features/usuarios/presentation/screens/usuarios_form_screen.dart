import 'package:flutter/material.dart';
import 'package:quipubox/features/usuarios/domain/entities/usuario.dart';

class UsuariosFormScreen extends StatefulWidget {
  final Usuario? usuario;
  const UsuariosFormScreen({super.key, this.usuario, Usuario? item});

  @override
  State<UsuariosFormScreen> createState() => _UsuariosFormScreenState();
}

class _UsuariosFormScreenState extends State<UsuariosFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            initialValue: widget.usuario?.nombreCompleto ?? '',
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            initialValue: widget.usuario?.email ?? '',
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          // Add more fields as necessary
        ],
      ),
    );
  }
}
