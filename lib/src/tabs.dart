import 'package:flutter/widgets.dart';
import 'package:shadcn/src/colors.dart';
import 'package:shadcn/src/theme.dart';

class TabEntry {
  const TabEntry({required this.label, this.icon});

  final Widget? icon;
  final Widget label;
}

class Tabs extends StatelessWidget {
  const Tabs({
    required this.content,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.actionButtons = const [],
  });

  final List<TabEntry> destinations;
  final List<Widget> actionButtons;

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  final Widget content;

  Widget _buildTabBar(BuildContext context) {
    final colorScheme = ShadcnTheme.of(context).colorScheme;

    var index = 0;
    final tabBarContent = <Widget>[];

    for (final destination in destinations) {
      final capturedIndex = index;

      tabBarContent.add(
        _TabLink(
          label: destination.label,
          selected: selectedIndex == index,
          onPressed: () => onDestinationSelected(capturedIndex),
        ),
      );
      index += 1;
    }

    return Row(
      children: [
        Container(
          height: 36,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: colorScheme.muted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: tabBarContent,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actionButtons,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBar(context),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _TabLink extends StatefulWidget {
  const _TabLink({
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final Widget label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  State<_TabLink> createState() => _TabLinkState();
}

class _TabLinkState extends State<_TabLink> {
  bool _isHovering = false;

  void _handleHoveringChange(bool isHovering) {
    if (_isHovering == isHovering) return;
    setState(() => _isHovering = isHovering);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _handleHoveringChange(true),
      onExit: (_) => _handleHoveringChange(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: widget.selected ? colorScheme.input : null,
            borderRadius: BorderRadius.circular(8),
            border: widget.selected
                ? Border.all(color: colorScheme.border)
                : Border.all(color: TWColors.transparent),
          ),
          child: DefaultTextStyle(
            style: theme.textTheme.labelMedium.withColor(
              _isHovering || widget.selected
                  ? null
                  : colorScheme.mutedForeground,
            ),
            child: widget.label,
          ),
        ),
      ),
    );
  }
}
