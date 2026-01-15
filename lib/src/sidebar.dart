import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:shadcn/src/button.dart';
import 'package:shadcn/src/icon_button.dart';
import 'package:shadcn/src/lucide_icons.dart';
import 'package:shadcn/src/theme.dart';

enum SidebarStyle { normal, insert, floating }

sealed class SidebarEntry {
  const SidebarEntry();
}

class SidebarLabel extends SidebarEntry {
  const SidebarLabel({required this.label});
  final Widget label;
}

class SidebarButton extends SidebarEntry {
  const SidebarButton({
    required this.label,
    this.icon,
    this.children = const [],
  });

  final Widget? icon;
  final Widget label;
  final List<SidebarSubButton> children;
}

class SidebarSubButton {
  const SidebarSubButton({required this.label});

  final Widget label;
}

enum _SidebarSlot { content, sidebar, drawer }

class Sidebar extends StatefulWidget {
  const Sidebar({
    required this.content,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.sidebarHeader,
    this.sidebarFooter,
  }) : sidebarStyle = SidebarStyle.normal;

  const Sidebar.insert({
    required this.content,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.sidebarHeader,
    this.sidebarFooter,
  }) : sidebarStyle = SidebarStyle.insert;

  const Sidebar.floating({
    required this.content,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.sidebarHeader,
    this.sidebarFooter,
  }) : sidebarStyle = SidebarStyle.floating;

  final SidebarStyle sidebarStyle;

  final Widget content;
  final Widget? sidebarHeader;
  final Widget? sidebarFooter;
  final List<SidebarEntry> destinations;

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _index = 0;

  Widget _buildSidebar(BuildContext context) {
    final colorScheme = ShadcnTheme.of(context).colorScheme;

    final sidebarContent = <Widget>[];

    for (final destination in widget.destinations) {
      sidebarContent.add(_buildDestination(destination));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.sidebar,
        border: Border(right: BorderSide(color: colorScheme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ?widget.sidebarHeader,
          ...sidebarContent,
          ?widget.sidebarFooter,
        ],
      ),
    );
  }

  Widget _buildDestination(SidebarEntry destination) {
    switch (destination) {
      case SidebarLabel():
        return _SidebarLabel(label: destination.label);
      case SidebarButton():
        final menuButton = _SidebarMenuButton(
          icon: destination.icon,
          label: destination.label,
          subButtons: destination.children,
          index: _index,
          selectedIndex: widget.selectedIndex,
          onDestinationSelected: widget.onDestinationSelected,
        );

        _index += destination.children.length + 1;
        return menuButton;
    }
  }

  Widget _buildContent(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.border),
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colorScheme.border)),
            ),
            child: Row(
              children: [
                IconButton.ghost(
                  icon: const Icon(LucideIcons.panelLeft),
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  color: colorScheme.border,
                  margin: const EdgeInsets.symmetric(vertical: 22),
                ),
                const SizedBox(width: 16),
                DefaultTextStyle.merge(
                  style: textTheme.title,
                  child: const Text('Home'),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: widget.content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ShadcnTheme.of(context).colorScheme;

    final mediaSize = MediaQuery.of(context).size;
    final isLargeScreen = mediaSize.width >= 700;

    final sidebar = _buildSidebar(context);

    return ColoredBox(
      color: colorScheme.background,
      child: CustomMultiChildLayout(
        delegate: _SidebarLayout(),
        children: [
          LayoutId(id: _SidebarSlot.content, child: _buildContent(context)),
          if (isLargeScreen) LayoutId(id: _SidebarSlot.sidebar, child: sidebar),
          if (!isLargeScreen)
            LayoutId(
              id: _SidebarSlot.drawer,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => print('close Drawer'),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    ),
                  ),
                  sidebar,
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SidebarLayout extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    double offsetX = 0;

    if (hasChild(_SidebarSlot.sidebar)) {
      final sidebarSize = layoutChild(
        _SidebarSlot.sidebar,
        BoxConstraints.tightFor(width: 257, height: size.height),
      );

      offsetX += sidebarSize.width;
      positionChild(_SidebarSlot.sidebar, Offset.zero);
    }

    layoutChild(
      _SidebarSlot.content,
      BoxConstraints.tightFor(width: size.width - offsetX, height: size.height),
    );
    positionChild(_SidebarSlot.content, Offset(offsetX, 0));

    if (hasChild(_SidebarSlot.drawer)) {
      layoutChild(
        _SidebarSlot.drawer,
        BoxConstraints.tightFor(width: size.width, height: size.height),
      );

      positionChild(_SidebarSlot.drawer, Offset.zero);
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class _SidebarLabel extends StatelessWidget {
  const _SidebarLabel({required this.label});

  final Widget label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 6),
      child: DefaultTextStyle.merge(
        style: theme.textTheme.labelSmall.withColor(
          theme.colorScheme.mutedForeground,
        ),
        child: label,
      ),
    );
  }
}

class _SidebarMenuButton extends StatefulWidget {
  const _SidebarMenuButton({
    required this.label,
    required this.subButtons,
    required this.index,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.icon,
  });

  final Widget? icon;
  final Widget label;

  final List<SidebarSubButton> subButtons;

  final int index;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<_SidebarMenuButton> createState() => _SidebarMenuButtonState();
}

class _SidebarMenuButtonState extends State<_SidebarMenuButton> {
  late final bool _isSelected;
  bool _isExpanded = false;

  late int _subIndex;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.index == widget.selectedIndex;
    _subIndex = widget.index + 1;
  }

  void _handleExpandingChange() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final subButtons = <Widget>[];

    if (widget.subButtons.isNotEmpty) {
      for (final subButton in widget.subButtons) {
        subButtons.add(
          _SidebarSubButton(
            label: subButton.label,
            index: _subIndex,
            selected: _subIndex == widget.selectedIndex,
            onDestinationSelected: widget.onDestinationSelected,
          ),
        );
        _subIndex += 1;
      }
    }

    return Column(
      spacing: 1,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Button.ghost(
              onPressed: () => widget.onDestinationSelected(widget.index),
              iconPrefix: widget.icon,
              label: DefaultTextStyle.merge(
                style: !_isSelected
                    ? theme.textTheme.body.withColor(null)
                    : null,
                child: widget.label,
              ),
            ),
            if (widget.subButtons.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(4),
                child: IconButton.ghost(
                  dimension: 24,
                  icon: Icon(
                    _isExpanded
                        ? LucideIcons.chevronDown
                        : LucideIcons.chevronRight,
                  ),
                  onPressed: _handleExpandingChange,
                ),
              ),
          ],
        ),
        if (_isExpanded)
          Row(
            children: [
              Container(
                width: 1,
                margin: const EdgeInsets.only(left: 16, right: 8),
                height: widget.subButtons.length * 28,
                color: theme.colorScheme.border,
              ),
              Expanded(child: Column(children: subButtons)),
              const SizedBox(width: 28),
            ],
          ),
      ],
    );
  }
}

class _SidebarSubButton extends StatelessWidget {
  const _SidebarSubButton({
    required this.label,
    required this.index,
    required this.selected,
    required this.onDestinationSelected,
  });

  final Widget label;

  final int index;
  final bool selected;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = ShadcnTheme.of(context).textTheme;

    return Button.ghost(
      selected: selected,
      height: 28,
      label: DefaultTextStyle.merge(
        style: selected ? textTheme.body.withColor(null) : null,
        child: label,
      ),
      onPressed: () => onDestinationSelected(index),
    );
  }
}
