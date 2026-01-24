import 'package:flutter/widgets.dart';
import 'package:shadcn/src/button.dart';
import 'package:shadcn/src/dropdown_menu.dart';
import 'package:shadcn/src/icon_button.dart';
import 'package:shadcn/src/lucide_icons.dart';
import 'package:shadcn/src/theme.dart';

class BreadcrumbItem {
  const BreadcrumbItem({
    required this.label,
    required this.onPressed,
  });

  final Widget label;
  final VoidCallback onPressed;
}

class Breadcrumb extends StatelessWidget {
  const Breadcrumb({required this.items, super.key});

  final List<BreadcrumbItem> items;

  List<Widget> _buildChildren(BuildContext context) {
    if (items.isEmpty) return [];

    final theme = ShadcnTheme.of(context);
    const separator = Icon(LucideIcons.chevronRight);

    Widget buildItem(BreadcrumbItem item, {bool isCurrent = false}) {
      if (isCurrent) return item.label;
      return _BreadcrumbLink(
        label: item.label,
        onPressed: item.onPressed,
      );
    }

    if (items.length <= 3) {
      return [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) separator,
          buildItem(items[i], isCurrent: i == items.length - 1),
        ],
      ];
    }

    final first = items.first;
    final last = items.last;
    final secondLast = items[items.length - 2];
    final hiddenItems = items.sublist(1, items.length - 2);

    return [
      buildItem(first),
      separator,
      DropdownMenu(
        buttonBuilder: (context, controller, _) {
          return IconButton.ghost(
            selected: controller.isOpen,
            dimension: 26,
            icon: Icon(
              LucideIcons.ellipsis,
              color: theme.colorScheme.mutedForeground,
            ),
            onPressed: controller.open,
          );
        },
        items: hiddenItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Button.ghost(
              label: item.label,
              onPressed: item.onPressed,
            ),
          );
        }).toList(),
      ),
      separator,
      buildItem(secondLast),
      separator,
      buildItem(last, isCurrent: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return DefaultTextStyle(
      style: theme.textTheme.body,
      child: IconTheme.merge(
        data: IconThemeData(color: theme.colorScheme.mutedForeground),
        child: Row(
          spacing: 8,
          children: _buildChildren(context),
        ),
      ),
    );
  }
}

class _BreadcrumbLink extends StatefulWidget {
  const _BreadcrumbLink({required this.label, required this.onPressed});

  final Widget label;
  final VoidCallback onPressed;

  @override
  State<_BreadcrumbLink> createState() => _BreadcrumbLinkState();
}

class _BreadcrumbLinkState extends State<_BreadcrumbLink> {
  bool _isHovering = false;

  void _handleHoveringChange(bool isHovering) {
    if (_isHovering == isHovering) return;
    setState(() => _isHovering = isHovering);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _handleHoveringChange(true),
      onExit: (_) => _handleHoveringChange(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: DefaultTextStyle(
          style: theme.textTheme.body.withColor(
            _isHovering ? null : theme.colorScheme.mutedForeground,
          ),
          child: widget.label,
        ),
      ),
    );
  }
}
