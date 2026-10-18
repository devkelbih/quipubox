import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quipubox/core/common/string_extensions.dart';

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
          decoration: const InputDecoration(labelText: 'Nombres'),
          validator: (value) {
            if (!value.hasText) {
              return 'Ingresa los nombres';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: apellidosController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Apellidos'),
          validator: (value) {
            if (!value.hasText) {
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
            LengthLimitingTextInputFormatter(9),
          ],
          decoration: const InputDecoration(labelText: 'Teléfono'),
          validator: (value) {
            // El teléfono es opcional.
            if (!value.hasText) {
              return null;
            }

            final telefono = value!.value;
            if (telefono.length != 9) {
              return 'El teléfono debe tener 9 dígitos';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Correo electrónico'),
          validator: (value) {
            if (!value.hasText) {
              return 'Ingresa el correo electrónico';
            }

            final email = value!.value;
            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

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
