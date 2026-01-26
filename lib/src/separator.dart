import 'package:flutter/widgets.dart';
import 'package:shadcn/src/theme.dart';

class Separator extends StatelessWidget {
  const Separator.vertical({
    super.key,
    this.thickness = 1,
    this.height = 1,
    this.indent = 0,
  }) : axis = Axis.vertical;

  const Separator.horizontal({
    super.key,
    this.thickness = 1,
    this.height = 1,
    this.indent = 0,
  }) : axis = Axis.horizontal;

  final double thickness;
  final double height;
  final double indent;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return Container(
      width: axis == Axis.horizontal ? null : thickness,
      height: axis == Axis.horizontal ? thickness : null,
      color: theme.colorScheme.border,
      margin: EdgeInsets.symmetric(
        vertical: axis == Axis.horizontal ? height / 2 : indent,
        horizontal: axis == Axis.horizontal ? indent : height / 2,
      ),
    );
  }
}
