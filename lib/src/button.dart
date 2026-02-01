import 'package:flutter/widgets.dart';
import 'package:shadcn/src/color_scheme.dart';
import 'package:shadcn/src/colors.dart';
import 'package:shadcn/src/theme.dart';

enum ButtonType {
  primary,
  secondary,
  outline,
  ghost,
  destructive
  ;

  Color hoverColor(ColorScheme colorScheme) => switch (this) {
    primary => colorScheme.primary.withValues(
      alpha: colorScheme.primary.a * .8,
    ),
    secondary => colorScheme.secondary.withValues(
      alpha: colorScheme.secondary.a * .8,
    ),
    outline => colorScheme.input.withValues(alpha: colorScheme.input.a * .5),
    ghost => colorScheme.muted,
    destructive => colorScheme.destructive.withValues(
      alpha: colorScheme.destructive.a * .3,
    ),
  };

  Color containerColor(ColorScheme colorScheme) => switch (this) {
    primary => colorScheme.primary,
    secondary => colorScheme.secondary,
    outline => colorScheme.input.withValues(alpha: colorScheme.input.a * .3),
    ghost => TWColors.transparent,
    destructive => colorScheme.destructive.withValues(
      alpha: colorScheme.destructive.a * .2,
    ),
  };

  Color foregroundColor(ColorScheme colorScheme) => switch (this) {
    primary => colorScheme.primaryForeground,
    secondary => colorScheme.secondaryForeground,
    outline => colorScheme.foreground,
    ghost => colorScheme.foreground,
    destructive => colorScheme.destructive,
  };

  Color borderColor(ColorScheme colorScheme) => switch (this) {
    primary => TWColors.transparent,
    secondary => TWColors.transparent,
    outline => colorScheme.input,
    ghost => TWColors.transparent,
    destructive => TWColors.transparent,
  };
}

class Button extends StatefulWidget {
  const Button({
    required this.label,
    required this.onPressed,
    super.key,
    this.height = 34,
    this.centerLabel = false,
    this.iconPrefix,
    this.iconSuffix,
    this.selected = false,
    this.disabled = false,
  }) : buttonType = ButtonType.primary;

  const Button.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.height = 34,
    this.centerLabel = false,
    this.iconPrefix,
    this.iconSuffix,
    this.selected = false,
    this.disabled = false,
  }) : buttonType = ButtonType.secondary;

  const Button.outline({
    required this.label,
    required this.onPressed,
    super.key,
    this.height = 34,
    this.centerLabel = false,
    this.iconPrefix,
    this.iconSuffix,
    this.selected = false,
    this.disabled = false,
  }) : buttonType = ButtonType.outline;

  const Button.ghost({
    required this.label,
    required this.onPressed,
    super.key,
    this.height = 34,
    this.centerLabel = false,
    this.iconPrefix,
    this.iconSuffix,
    this.selected = false,
    this.disabled = false,
  }) : buttonType = ButtonType.ghost;

  const Button.destructive({
    required this.label,
    required this.onPressed,
    super.key,
    this.height = 34,
    this.centerLabel = false,
    this.iconPrefix,
    this.iconSuffix,
    this.selected = false,
    this.disabled = false,
  }) : buttonType = ButtonType.destructive;

  final double height;
  final Widget label;
  final bool centerLabel;
  final VoidCallback onPressed;

  final Widget? iconPrefix;
  final Widget? iconSuffix;

  final bool selected;
  final bool disabled;

  final ButtonType buttonType;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late bool _isHovering;

  @override
  void initState() {
    super.initState();
    _isHovering = widget.selected;
  }

  @override
  void didUpdateWidget(covariant Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      _isHovering = widget.selected;
    }
  }

  void _handleHoveringChange(bool isHovering) {
    if (widget.selected || widget.disabled || _isHovering == isHovering) return;
    setState(() => _isHovering = isHovering);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;

    final hoverColor = widget.buttonType.hoverColor(colorScheme);
    final containerColor = widget.buttonType.containerColor(colorScheme);
    final foregroundColor = widget.buttonType.foregroundColor(colorScheme);
    final borderColor = widget.buttonType.borderColor(colorScheme);

    final labelWidget = DefaultTextStyle(
      style: theme.textTheme.labelMedium
          .withColor(foregroundColor)
          .merge(DefaultTextStyle.of(context).style),
      child: widget.label,
    );

    Widget contentGroup = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        if (widget.iconPrefix != null) widget.iconPrefix!,
        Flexible(child: labelWidget),
      ],
    );

    if (widget.centerLabel) {
      contentGroup = Expanded(child: Center(child: contentGroup));
    } else {
      contentGroup = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: contentGroup,
      );
    }

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
              border: Border.all(color: borderColor),
            ),
            child: IconTheme.merge(
              data: IconThemeData(
                color: foregroundColor,
                size: widget.height / 2,
              ),
              child: Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [contentGroup, ?widget.iconSuffix],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
