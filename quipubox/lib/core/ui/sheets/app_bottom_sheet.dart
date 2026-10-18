import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;

  final Widget Function(BuildContext context, ScrollController controller)
  builder;

  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Widget? trailing;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.builder,
    this.initialChildSize = 0.4,
    this.minChildSize = 0.2,
    this.maxChildSize = 0.7,
    this.trailing,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget Function(BuildContext context, ScrollController controller)
    builder,
    double initialChildSize = 0.5,
    double minChildSize = 0.2,
    double maxChildSize = 0.7,
    Widget? trailing,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      builder: (_) => AppBottomSheet(
        title: title,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        trailing: trailing,
        builder: builder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) {
          return Material(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (trailing != null) trailing!,
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                Expanded(
                  child: SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    bottom: true,
                    child: builder(context, scrollController),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
