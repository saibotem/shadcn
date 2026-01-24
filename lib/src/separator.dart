import 'package:flutter/widgets.dart';
import 'package:shadcn/src/theme.dart';

class HorizontalSeparator extends StatelessWidget {
  const HorizontalSeparator({super.key, this.height = 1, this.indent = 12});

  final double height;
  final double indent;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return Container(
      height: height,
      color: theme.colorScheme.border,
      margin: EdgeInsets.symmetric(vertical: height / 2, horizontal: indent),
    );
  }
}

class VerticalSeparator extends StatelessWidget {
  const VerticalSeparator({super.key, this.width = 1, this.indent = 12});

  final double width;
  final double indent;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return Container(
      width: width,
      color: theme.colorScheme.border,
      margin: EdgeInsets.symmetric(vertical: indent, horizontal: width / 2),
    );
  }
}
