import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsuarioDatosForm extends StatelessWidget {
  final TextEditingController nombresController;
  final TextEditingController apellidosController;
  final TextEditingController telefonoController;
  final TextEditingController emailController;

  const UsuarioDatosForm({
    super.key,
    required this.nombresController,
    required this.apellidosController,
    required this.telefonoController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nombresController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nombres',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa los nombres';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: apellidosController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Apellidos',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa los apellidos';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: telefonoController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            labelText: 'Teléfono',
          ),
          validator: (value) {
            final telefono = value?.trim() ?? '';

            // El teléfono es opcional.
            if (telefono.isEmpty) {
              return null;
            }

            if (!RegExp(r'^\d+$').hasMatch(telefono)) {
              return 'Ingresa un teléfono válido';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Correo electrónico',
          ),
          validator: (value) {
            final email = value?.trim() ?? '';

            if (email.isEmpty) {
              return 'Ingresa el correo electrónico';
            }

            final emailRegex = RegExp(
              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
            );

            if (!emailRegex.hasMatch(email)) {
              return 'Ingresa un correo electrónico válido';
            }

            return null;
          },
        ),
      ],
    );
  }
}