import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../viewmodels/company_viewmodel.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CompanyViewModel>().loadCurrentCompany());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CompanyViewModel>();

    return AppScaffold(
      title: 'Empresa actual',
      body: Builder(
        builder: (_) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (vm.errorMessage != null) return Center(child: Text(vm.errorMessage!));
          final company = vm.company;
          if (company == null) return const Center(child: Text('No hay datos de empresa.'));

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.business_rounded, size: 48, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 14),
                      Text(company.nombreComercial, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(company.razonSocial),
                      const SizedBox(height: 20),
                      _Info(label: 'ID empresa', value: company.idEmpresa.toString()),
                      _Info(label: 'RUC', value: company.ruc ?? 'No registrado'),
                      _Info(label: 'Teléfono', value: company.telefono ?? 'No registrado'),
                      _Info(label: 'Dirección', value: company.direccion ?? 'No registrada'),
                      _Info(label: 'Estado', value: company.estado ? 'Activo' : 'Inactivo'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;

  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
