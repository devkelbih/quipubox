import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/cliente_request_model.dart';
import '../../domain/entities/cliente.dart';
import '../viewmodels/clientes_viewmodel.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? item;
  const ClienteFormScreen({super.key, this.item});
  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final apodoController = TextEditingController();
  final telefonoController = TextEditingController();
  final observacionesController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      nombresController.text = widget.item!.nombres.toString();
      apellidosController.text = widget.item!.apellidos.toString();
      apodoController.text = widget.item!.apodo.toString();
      telefonoController.text = widget.item!.telefono.toString();
      observacionesController.text = widget.item!.observaciones.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}
