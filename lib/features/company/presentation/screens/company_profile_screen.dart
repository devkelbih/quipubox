import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
class CompanyProfileScreen extends StatelessWidget { const CompanyProfileScreen({super.key}); @override Widget build(BuildContext context){ final user=context.watch<AuthViewModel>().user; return AppScaffold(title: 'Empresa actual', body: ListView(padding: const EdgeInsets.all(16), children: [Card(child: ListTile(leading: const Icon(Icons.business_rounded), title: Text(user?.empresaNombre ?? 'Empresa', style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text('ID empresa: ${user?.idEmpresa ?? 1}\nSede: ${user?.sedeNombre ?? '-'}\nRol: ${user?.rolNombre ?? '-'}')))])); } }
