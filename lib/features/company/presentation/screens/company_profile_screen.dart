import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;
    return AppScaffold(
      title: 'Empresa actual',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.business_rounded),
              title: Text(
                user?.empresa.nombreComercial ?? 'Empresa',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              
            ),
          ),
        ],
      ),
    );
  }
}
