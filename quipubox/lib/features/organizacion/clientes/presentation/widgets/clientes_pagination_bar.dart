import 'package:flutter/material.dart';

class ClientesPaginationBar extends StatelessWidget {
  final int page;
  final int totalPages;
  final int total;
  final bool busy;
  final ValueChanged<int> onPage;
  const ClientesPaginationBar({
    super.key,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.busy,
    required this.onPage,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Página anterior',
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: busy || page <= 1 ? null : () => onPage(page - 1),
        ),
        Expanded(
          child: Text(
            'Página $page de ${totalPages < 1 ? 1 : totalPages} · $total clientes',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        IconButton(
          tooltip: 'Página siguiente',
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: busy || page >= totalPages ? null : () => onPage(page + 1),
        ),
      ],
    ),
  );
}
