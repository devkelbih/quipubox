import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClienteDatosForm extends StatelessWidget {
  final TextEditingController nombresController;
  final TextEditingController apellidosController;
  final TextEditingController apodoController;
  final TextEditingController telefonoController;
  final TextEditingController observacionesController;

  const ClienteDatosForm({
    super.key,
    required this.nombresController,
    required this.apellidosController,
    required this.apodoController,
    required this.telefonoController,
    required this.observacionesController,
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
          decoration: const InputDecoration(labelText: 'Apellidos'),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: apodoController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Apodo'),
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
            final telefono = value?.trim() ?? '';

            if (telefono.isEmpty) {
              return null;
            }

            if (telefono.length != 9) {
              return 'El teléfono debe tener 9 dígitos';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: observacionesController,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Observaciones',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}
