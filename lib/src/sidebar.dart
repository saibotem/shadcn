import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:shadcn/src/button.dart';
import 'package:shadcn/src/icon_button.dart';
import 'package:shadcn/src/lucide_icons.dart';
import 'package:shadcn/src/theme.dart';

enum _SidebarSlot { body, sidebar, drawer }

class Sidebar extends StatelessWidget {
  const Sidebar({
    required this.items,
    required this.body,
    super.key,
    this.header,
    this.footer,
  }) : insertStyle = false;
  const Sidebar.insert({
    required this.items,
    required this.body,
    super.key,
    this.header,
    this.footer,
  }) : insertStyle = true;

  final bool insertStyle;
  final Widget? header;
  final List<SidebarGroup> items;
  final Widget? footer;
  final Widget body;

  Widget _buildSidebar(BuildContext context) {
    final colorScheme = ShadcnTheme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: !insertStyle
          ? BoxDecoration(
              color: colorScheme.sidebar,
              border: Border(right: BorderSide(color: colorScheme.border)),
            )
          : null,
      child: Column(children: [?header, ...items, ?footer]),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = ShadcnTheme.of(context).colorScheme;

    return Container(
      margin: insertStyle ? const EdgeInsets.fromLTRB(0, 8, 8, 8) : null,
      decoration: insertStyle
          ? BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.border),
            )
          : null,
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colorScheme.border)),
            ),
            child: Row(
              spacing: 16,
              children: [
                const Icon(LucideIcons.panelLeft),
                Container(
                  width: 1,
                  color: colorScheme.border,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                const Text('Home'),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: body),
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
      color: insertStyle ? colorScheme.sidebar : colorScheme.background,
      child: CustomMultiChildLayout(
        delegate: _SidebarLayout(),
        children: [
          LayoutId(id: _SidebarSlot.body, child: _buildContent(context)),
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
      _SidebarSlot.body,
      BoxConstraints.tightFor(width: size.width - offsetX, height: size.height),
    );
    positionChild(_SidebarSlot.body, Offset(offsetX, 0));

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

class SidebarGroup extends StatelessWidget {
  const SidebarGroup({required this.menuButtons, super.key, this.label});

  final Text? label;
  final List<SidebarMenuButton> menuButtons;

  @override
  Widget build(BuildContext context) {
    final textTheme = ShadcnTheme.of(context).textTheme;

    return Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
            child: DefaultTextStyle(style: textTheme.muted, child: label!),
          ),
        ...menuButtons,
      ],
    );
  }
}

class SidebarMenuButton extends StatefulWidget {
  const SidebarMenuButton({
    required this.label,
    required this.menuSubButtons,
    super.key,
    this.icon,
  });

  final Text label;
  final Icon? icon;
  final List<SidebarMenuSubButton> menuSubButtons;

  @override
  State<SidebarMenuButton> createState() => _SidebarMenuButtonState();
}

class _SidebarMenuButtonState extends State<SidebarMenuButton> {
  bool _isExpanded = false;

  void _handleExpandingChange() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ShadcnTheme.of(context).colorScheme;

    return Column(
      spacing: 1,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Button.ghost(
              onPressed: () {},
              label: widget.label,
              iconPrefix: widget.icon,
            ),
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
                height: widget.menuSubButtons.length * 28,
                color: colorScheme.border,
              ),
              Expanded(child: Column(children: widget.menuSubButtons)),
              const SizedBox(width: 28),
            ],
          ),
      ],
    );
  }
}

class SidebarMenuSubButton extends StatelessWidget {
  const SidebarMenuSubButton({required this.label, super.key});

  final Text label;

  @override
  Widget build(BuildContext context) {
    return Button.ghost(height: 28, label: label, onPressed: () {});
  }
}
