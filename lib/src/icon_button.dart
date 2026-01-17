import 'package:flutter/widgets.dart';
import 'package:shadcn/src/button.dart';
import 'package:shadcn/src/theme.dart';

class IconButton extends StatefulWidget {
  const IconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.dimension = 32,
    this.disabled = false,
  }) : buttonType = ButtonType.primary;

  const IconButton.secondary({
    required this.icon,
    required this.onPressed,
    super.key,
    this.dimension = 32,
    this.disabled = false,
  }) : buttonType = ButtonType.secondary;

  const IconButton.ghost({
    required this.icon,
    required this.onPressed,
    super.key,
    this.dimension = 32,
    this.disabled = false,
  }) : buttonType = ButtonType.ghost;

  const IconButton.destructive({
    required this.icon,
    required this.onPressed,
    super.key,
    this.dimension = 32,
    this.disabled = false,
  }) : buttonType = ButtonType.destructive;

  final Widget icon;
  final bool disabled;
  final double dimension;
  final ButtonType buttonType;
  final VoidCallback onPressed;

  @override
  State<IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<IconButton> {
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
            height: widget.dimension,
            width: widget.dimension,
            decoration: BoxDecoration(
              color: _isHovering ? hoverColor : containerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconTheme.merge(
              data: IconThemeData(
                size: 16,
                color: foregroundColor,
              ),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}
