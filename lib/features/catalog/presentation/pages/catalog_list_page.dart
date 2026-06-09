import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_module.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../widgets/catalog_form_sheet.dart';

class CatalogListPage extends StatefulWidget {
  final CatalogModule module;

  const CatalogListPage({
    super.key,
    required this.module,
  });

  @override
  State<CatalogListPage> createState() => _CatalogListPageState();
}

class _CatalogListPageState extends State<CatalogListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CatalogViewModel>().load(widget.module));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatalogViewModel>();

    return AppScaffold(
      title: widget.module.title,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: vm.isSaving ? null : () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo'),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<CatalogViewModel>().load(widget.module),
        child: Builder(
          builder: (_) {
            if (vm.isLoading) return const Center(child: CircularProgressIndicator());

            if (vm.errorMessage != null) {
              return ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _ErrorPanel(
                    message: vm.errorMessage!,
                    onRetry: () => context.read<CatalogViewModel>().load(widget.module),
                  ),
                ],
              );
            }

            if (vm.items.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _EmptyPanel(title: widget.module.title),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemBuilder: (_, index) => _CatalogCard(
                item: vm.items[index],
                onEdit: () => _openForm(context, item: vm.items[index]),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: vm.items.length,
            );
          },
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {CatalogItem? item}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<CatalogViewModel>(),
        child: CatalogFormSheet(
          module: widget.module,
          item: item,
        ),
      ),
    );

    if (!context.mounted) return;
    if (result == true) {
      AppToast.show(
        context,
        message: item == null ? 'Registro creado correctamente.' : 'Registro actualizado correctamente.',
        type: ToastType.success,
      );
    }
  }
}

class _CatalogCard extends StatelessWidget {
  final CatalogItem item;
  final VoidCallback onEdit;

  const _CatalogCard({
    required this.item,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: colors.primary.withValues(alpha: .12),
          child: Icon(Icons.inventory_2_rounded, color: colors.primary),
        ),
        title: Text(item.title.isEmpty ? 'Sin nombre' : item.title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.subtitle.isEmpty ? 'Empresa ID: ${item.idEmpresa == 0 ? AppConfig.currentCompanyId : item.idEmpresa}' : item.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_rounded),
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  final String title;

  const _EmptyPanel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 54, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text('Sin registros', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('Aún no hay datos para $title. Usa el botón Nuevo para registrar información.'),
          ],
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorPanel({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(Icons.error_outline_rounded, size: 54, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text('No se pudo cargar', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
