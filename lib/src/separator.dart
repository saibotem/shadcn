import 'package:flutter/widgets.dart';
import 'package:shadcn/src/theme.dart';

class HorizontalSeparator extends StatelessWidget {
  const HorizontalSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return Container(
      height: 1,
      color: theme.colorScheme.border,
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class VerticalSeparator extends StatelessWidget {
  const VerticalSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return Container(
      width: 1,
      color: theme.colorScheme.border,
      margin: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}
