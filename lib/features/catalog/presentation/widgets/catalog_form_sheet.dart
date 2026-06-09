import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/utils/app_toast.dart';
import '../../domain/entities/catalog_field.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_module.dart';
import '../viewmodels/catalog_viewmodel.dart';

class CatalogFormSheet extends StatefulWidget {
  final CatalogModule module;
  final CatalogItem? item;

  const CatalogFormSheet({
    super.key,
    required this.module,
    this.item,
  });

  @override
  State<CatalogFormSheet> createState() => _CatalogFormSheetState();
}

class _CatalogFormSheetState extends State<CatalogFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectValues = {};
  final Map<String, bool> _boolValues = {};

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    for (final field in widget.module.fields) {
      final rawValue = widget.item?.data[field.key];
      if (field.type == CatalogFieldType.select) {
        _selectValues[field.key] = rawValue?.toString();
      } else if (field.type == CatalogFieldType.booleanValue) {
        _boolValues[field.key] = rawValue == true || rawValue?.toString() == 'true';
      } else {
        _controllers[field.key] = TextEditingController(text: rawValue?.toString() ?? '');
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatalogViewModel>();
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: .88,
        minChildSize: .55,
        maxChildSize: .96,
        builder: (_, controller) {
          return Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _isEditing ? 'Editar ${widget.module.title}' : 'Nuevo registro',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Empresa actual: ID ${AppConfig.currentCompanyId}. Este dato se envía automáticamente al crear.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 18),
                  ...widget.module.fields.map(_buildField),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: vm.isSaving ? null : _submit,
                    icon: vm.isSaving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save_rounded),
                    label: Text(vm.isSaving ? 'Guardando...' : 'Guardar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(CatalogField field) {
    switch (field.type) {
      case CatalogFieldType.select:
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: DropdownButtonFormField<String>(
            value: field.options.contains(_selectValues[field.key]) ? _selectValues[field.key] : null,
            decoration: InputDecoration(labelText: field.label),
            items: field.options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
            validator: (value) => field.required && (value == null || value.isEmpty) ? 'Campo requerido' : null,
            onChanged: (value) => setState(() => _selectValues[field.key] = value),
          ),
        );
      case CatalogFieldType.booleanValue:
        return SwitchListTile(
          value: _boolValues[field.key] ?? false,
          title: Text(field.label),
          onChanged: (value) => setState(() => _boolValues[field.key] = value),
        );
      case CatalogFieldType.number:
      case CatalogFieldType.phone:
      case CatalogFieldType.email:
      case CatalogFieldType.url:
      case CatalogFieldType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: TextFormField(
            controller: _controllers[field.key],
            maxLines: field.maxLines,
            keyboardType: _keyboardType(field.type),
            decoration: InputDecoration(labelText: field.label),
            validator: (value) {
              if (field.required && (value == null || value.trim().isEmpty)) return 'Campo requerido';
              return null;
            },
          ),
        );
    }
  }

  TextInputType _keyboardType(CatalogFieldType type) {
    return switch (type) {
      CatalogFieldType.number => TextInputType.number,
      CatalogFieldType.phone => TextInputType.phone,
      CatalogFieldType.email => TextInputType.emailAddress,
      CatalogFieldType.url => TextInputType.url,
      _ => TextInputType.text,
    };
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = <String, dynamic>{};
    for (final field in widget.module.fields) {
      if (field.type == CatalogFieldType.select) {
        payload[field.key] = _selectValues[field.key];
      } else if (field.type == CatalogFieldType.booleanValue) {
        payload[field.key] = _boolValues[field.key] ?? false;
      } else {
        final text = _controllers[field.key]?.text.trim() ?? '';
        payload[field.key] = field.type == CatalogFieldType.number ? int.tryParse(text) : text;
      }
    }

    final ok = await context.read<CatalogViewModel>().save(
          widget.module,
          payload,
          id: widget.item?.id,
        );

    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      AppToast.show(
        context,
        message: context.read<CatalogViewModel>().errorMessage ?? 'No se pudo guardar.',
        type: ToastType.error,
      );
    }
  }
}
