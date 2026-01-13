import 'package:flutter/widgets.dart';
import 'package:shadcn/src/color_scheme.dart';
import 'package:shadcn/src/colors.dart';
import 'package:shadcn/src/theme.dart';

enum ButtonType {
  primary,
  secondary,
  ghost,
  destructive
  ;

  Color hoverColor(ColorScheme colorScheme) => switch (this) {
    primary => colorScheme.primary.withValues(alpha: 0.9),
    secondary => colorScheme.secondary.withValues(alpha: 0.9),
    ghost => colorScheme.secondary,
    destructive => colorScheme.destructive.withValues(alpha: 0.9),
  };

  Color containerColor(ColorScheme colorScheme) => switch (this) {
    primary => colorScheme.primary,
    secondary => colorScheme.secondary,
    ghost => TWColors.transparent,
    destructive => colorScheme.destructive,
  };

  Color foregroundColor(ColorScheme colorScheme) => switch (this) {
    primary => colorScheme.primaryForeground,
    secondary => colorScheme.secondaryForeground,
    ghost => colorScheme.foreground,
    destructive => TWColors.white,
  };
}

class Button extends StatefulWidget {
  const Button({
    required this.onPressed,
    required this.label,
    super.key,
    this.iconPrefix,
    this.iconSuffix,
    this.height = 32,
    this.disabled = false,
  }) : buttonType = ButtonType.primary;

  const Button.secondary({
    required this.onPressed,
    required this.label,
    super.key,
    this.iconPrefix,
    this.iconSuffix,
    this.height = 32,
    this.disabled = false,
  }) : buttonType = ButtonType.secondary;

  const Button.ghost({
    required this.onPressed,
    required this.label,
    super.key,
    this.iconPrefix,
    this.iconSuffix,
    this.height = 32,
    this.disabled = false,
  }) : buttonType = ButtonType.ghost;

  const Button.destructive({
    required this.onPressed,
    required this.label,
    super.key,
    this.iconPrefix,
    this.iconSuffix,
    this.height = 32,
    this.disabled = false,
  }) : buttonType = ButtonType.destructive;

  final Text label;
  final bool disabled;
  final double height;
  final Icon? iconPrefix;
  final Icon? iconSuffix;
  final ButtonType buttonType;
  final VoidCallback onPressed;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isHovering = false;

  void _handleHoveringChange(bool isHovering) {
    if (widget.disabled || _isHovering == isHovering) return;
    setState(() => _isHovering = isHovering);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;

    final hoverColor = widget.buttonType.hoverColor(colorScheme);
    final containerColor = widget.buttonType.containerColor(colorScheme);
    final foregroundColor = widget.buttonType.foregroundColor(colorScheme);

    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => _handleHoveringChange(true),
      onExit: (_) => _handleHoveringChange(false),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        child: Opacity(
          opacity: widget.disabled ? 0.5 : 1,
          child: Container(
            height: widget.height,
            padding: EdgeInsets.symmetric(horizontal: widget.height / 4),
            decoration: BoxDecoration(
              color: _isHovering ? hoverColor : containerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconTheme.merge(
              data: IconThemeData(
                color: foregroundColor,
                size: widget.height / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ?widget.iconPrefix,
                      DefaultTextStyle(
                        style: theme.textTheme.small.copyWith(
                          color: foregroundColor,
                        ),
                        child: widget.label,
                      ),
                    ],
                  ),

                  ?widget.iconSuffix,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
