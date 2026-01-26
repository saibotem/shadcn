import 'package:flutter/widgets.dart';
import 'package:shadcn/src/theme.dart';

class Scrollbar extends StatefulWidget {
  const Scrollbar.horizontal({
    required this.child,
    required this.controller,
    super.key,
    this.padding,
    this.fullScreen = false,
  }) : axis = Axis.horizontal;
  const Scrollbar.vertical({
    required this.child,
    required this.controller,
    super.key,
    this.padding,
    this.fullScreen = false,
  }) : axis = Axis.vertical;

  final Widget child;
  final bool fullScreen;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final Axis axis;

  @override
  State<Scrollbar> createState() => _ScrollbarState();
}

class _ScrollbarState extends State<Scrollbar> {
  bool _scrollbarVisibility = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    var child = widget.child;

    if (_scrollbarVisibility && !widget.fullScreen) {
      child = Padding(
        padding: widget.axis == Axis.horizontal
            ? const EdgeInsets.only(bottom: 16)
            : const EdgeInsets.only(right: 16),
        child: widget.child,
      );
    }

    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        final canScroll = notification.metrics.maxScrollExtent > 0;
        if (canScroll != _scrollbarVisibility) {
          setState(() => _scrollbarVisibility = canScroll);
        }

        return false;
      },
      child: RawScrollbar(
        controller: widget.controller,
        thumbVisibility: true,
        radius: const Radius.circular(6),
        thickness: 12,
        thumbColor: theme.colorScheme.border,
        padding:
            widget.padding ??
            EdgeInsets.symmetric(
              vertical: widget.axis == Axis.horizontal ? 8 : 12,
              horizontal: widget.axis == Axis.horizontal ? 12 : 8,
            ),
        child: child,
      ),
    );
  }
}
