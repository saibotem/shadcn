import 'package:flutter/widgets.dart';
import 'package:shadcn/src/theme.dart';

class Card extends StatelessWidget {
  const Card({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 12,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.card,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colorScheme.border),
      ),
      child: child,
    );
  }
}
