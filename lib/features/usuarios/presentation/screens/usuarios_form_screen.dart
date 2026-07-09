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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario == null ? 'Crear Usuario' : 'Editar Usuario'),
      ),
      body: Center(
        child: Text('Formulario para ${widget.usuario == null ? 'crear' : 'editar'} usuario'),
      ),
    );
  }
} 