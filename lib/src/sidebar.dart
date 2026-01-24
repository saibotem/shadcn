import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:shadcn/src/button.dart';
import 'package:shadcn/src/icon_button.dart';
import 'package:shadcn/src/lucide_icons.dart';
import 'package:shadcn/src/separator.dart';
import 'package:shadcn/src/theme.dart';
import 'package:window_manager/window_manager.dart';

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
    this.isDestination = true,
    this.subButtons = const [],
  });

  final Widget? icon;
  final Widget label;
  final bool isDestination;
  final List<SidebarSubButton> subButtons;
}

class SidebarSubButton {
  const SidebarSubButton({required this.label});

  final Widget label;
}

class Sidebar extends StatefulWidget {
  const Sidebar({
    required this.content,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.appBarTitle,
    this.appBarActions,
    this.sidebarHeader,
    this.sidebarFooter,
  }) : sidebarStyle = SidebarStyle.normal;

  const Sidebar.insert({
    required this.content,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.appBarTitle,
    this.appBarActions,
    this.sidebarHeader,
    this.sidebarFooter,
  }) : sidebarStyle = SidebarStyle.insert;

  const Sidebar.floating({
    required this.content,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
    this.appBarTitle,
    this.appBarActions,
    this.sidebarHeader,
    this.sidebarFooter,
  }) : sidebarStyle = SidebarStyle.floating;

  final Widget? appBarTitle;
  final List<Widget>? appBarActions;

  final SidebarStyle sidebarStyle;
  final Widget? sidebarHeader;
  final Widget? sidebarFooter;
  final List<SidebarEntry> destinations;

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  final Widget content;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isExpanded = true;
  bool _isLargeScreen = true;
  bool _isWindowManagerInitialized = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeWindowManager());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isLargeScreen = MediaQuery.of(context).size.width >= 800;
    if (isLargeScreen != _isLargeScreen) {
      setState(() {
        _isLargeScreen = isLargeScreen;
        _isExpanded = isLargeScreen;
      });
    }
  }

  Future<void> _initializeWindowManager() async {
    if (!(Platform.isWindows || Platform.isMacOS || Platform.isLinux)) return;
    await windowManager.ensureInitialized();
    _isWindowManagerInitialized = true;
  }

  void _handleExpandingChange() {
    setState(() => _isExpanded = !_isExpanded);
  }

  void _onDestinationSelected(int value) {
    if (!_isLargeScreen) _handleExpandingChange();
    widget.onDestinationSelected(value);
  }

  Widget _buildSidebar(BuildContext context) {
    final colorScheme = ShadcnTheme.of(context).colorScheme;

    var index = 0;
    final sidebarContent = <Widget>[];

    for (final destination in widget.destinations) {
      switch (destination) {
        case SidebarLabel():
          if (index != 0) sidebarContent.add(const SizedBox(height: 16));
          sidebarContent.add(_SidebarLabel(label: destination.label));
        case SidebarButton():
          final subButtons = <_SidebarSubButton>[];

          if (destination.subButtons.isNotEmpty) {
            var subIndex = index + (destination.isDestination ? 1 : 0);
            for (final subButton in destination.subButtons) {
              subButtons.add(
                _SidebarSubButton(
                  label: subButton.label,
                  index: subIndex,
                  selected: subIndex == widget.selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                ),
              );
              subIndex += 1;
            }
          }

          final menuButton = _SidebarMenuButton(
            icon: destination.icon,
            label: destination.label,
            isDestination: destination.isDestination,
            subButtons: subButtons,
            index: index,
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: _onDestinationSelected,
          );

          if (destination.isDestination) index += 1;
          index += destination.subButtons.length;
          sidebarContent.add(menuButton);
      }
    }

    final border = switch (widget.sidebarStyle) {
      SidebarStyle.normal => Border(
        right: BorderSide(color: colorScheme.border),
      ),
      SidebarStyle.insert => null,
      SidebarStyle.floating => Border.all(color: colorScheme.border),
    };

    return AnimatedContainer(
      width: _isExpanded ? 240 : 0,
      duration: const Duration(milliseconds: 200),
      margin: widget.sidebarStyle == SidebarStyle.floating
          ? const EdgeInsets.all(8)
          : null,
      decoration: BoxDecoration(
        color: colorScheme.sidebar,
        borderRadius: widget.sidebarStyle == SidebarStyle.floating
            ? BorderRadius.circular(16)
            : null,
        border: border,
      ),
      child: OverflowBox(
        minWidth: 238,
        maxWidth: 238,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ?widget.sidebarHeader,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sidebarContent,
                  ),
                ),
              ),
              ?widget.sidebarFooter,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: widget.sidebarStyle == SidebarStyle.insert
          ? const EdgeInsets.fromLTRB(0, 8, 8, 8)
          : null,
      decoration: BoxDecoration(
        color: widget.sidebarStyle == SidebarStyle.insert
            ? colorScheme.background
            : null,
        borderRadius: widget.sidebarStyle == SidebarStyle.insert
            ? BorderRadius.circular(16)
            : null,
      ),
      child: Column(
        children: [
          GestureDetector(
            onPanStart: (details) async {
              if (!_isWindowManagerInitialized) return;
              await windowManager.startDragging();
            },
            onDoubleTap: () async {
              if (!_isWindowManagerInitialized) return;
              if (await windowManager.isMaximized()) {
                await windowManager.unmaximize();
              } else {
                await windowManager.maximize();
              }
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colorScheme.border)),
              ),
              child: Row(
                spacing: 8,
                children: [
                  IconButton.ghost(
                    icon: const Icon(LucideIcons.panelLeft),
                    onPressed: _handleExpandingChange,
                  ),
                  const VerticalSeparator(),
                  Expanded(
                    child: widget.appBarTitle != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: DefaultTextStyle.merge(
                              style: textTheme.title,
                              child: widget.appBarTitle!,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (widget.appBarActions != null) ...widget.appBarActions!,
                  const VerticalSeparator(),
                  const _WindowButtons(),
                ],
              ),
            ),
          ),
          Expanded(child: widget.content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ShadcnTheme.of(context).colorScheme;

    final child = _isLargeScreen
        ? Row(
            children: [
              _buildSidebar(context),
              Expanded(child: _buildContent(context)),
            ],
          )
        : Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: _isExpanded,
                  child: _buildContent(context),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !_isExpanded,
                  child: GestureDetector(
                    onTap: _handleExpandingChange,
                    behavior: HitTestBehavior.translucent,
                    child: AnimatedOpacity(
                      opacity: _isExpanded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
              _buildSidebar(context),
            ],
          );

    return ColoredBox(
      color: widget.sidebarStyle == SidebarStyle.insert
          ? colorScheme.sidebar
          : colorScheme.background,
      child: child,
    );
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
    required this.icon,
    required this.label,
    required this.isDestination,
    required this.subButtons,
    required this.index,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget? icon;
  final Widget label;
  final bool isDestination;

  final List<_SidebarSubButton> subButtons;

  final int index;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<_SidebarMenuButton> createState() => _SidebarMenuButtonState();
}

class _SidebarMenuButtonState extends State<_SidebarMenuButton> {
  bool _isExpanded = false;

  void _handleExpandingChange([bool? expand]) {
    setState(() => _isExpanded = expand ?? !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    final isSelected =
        widget.index == widget.selectedIndex && widget.isDestination;

    return Column(
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Button.ghost(
              selected: isSelected,
              onPressed: () {
                if (widget.isDestination) {
                  widget.onDestinationSelected(widget.index);
                  _handleExpandingChange(true);
                } else {
                  _handleExpandingChange();
                }
              },
              iconPrefix: widget.icon,
              label: DefaultTextStyle.merge(
                style: !isSelected
                    ? theme.textTheme.body.withColor(null)
                    : null,
                child: widget.label,
              ),
              iconSuffix: widget.isDestination
                  ? null
                  : Icon(
                      _isExpanded
                          ? LucideIcons.chevronDown
                          : LucideIcons.chevronRight,
                    ),
            ),
            if (widget.subButtons.isNotEmpty && widget.isDestination)
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
                height: widget.subButtons.length * 32,
                color: theme.colorScheme.border,
              ),
              Expanded(
                child: Column(
                  spacing: 4,
                  children: [const SizedBox.shrink(), ...widget.subButtons],
                ),
              ),
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
        style: !selected ? textTheme.body.withColor(null) : null,
        child: label,
      ),
      onPressed: () => onDestinationSelected(index),
    );
  }
}

class _WindowButtons extends StatefulWidget {
  const _WindowButtons();

  @override
  State<_WindowButtons> createState() => _MaximizeWindowButtonState();
}

class _MaximizeWindowButtonState extends State<_WindowButtons>
    with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    unawaited(_init());
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _init() async {
    final isMaximized = await windowManager.isMaximized();
    setState(() {
      _isMaximized = isMaximized;
    });
  }

  @override
  void onWindowMaximize() {
    setState(() {
      _isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      _isMaximized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      children: [
        IconButton.ghost(
          icon: const Icon(LucideIcons.minus),
          onPressed: windowManager.minimize,
        ),
        IconButton.ghost(
          icon: Icon(_isMaximized ? LucideIcons.copy : LucideIcons.square),
          onPressed: () async {
            if (_isMaximized) {
              await windowManager.unmaximize();
            } else {
              await windowManager.maximize();
            }
          },
        ),
        IconButton.ghost(
          icon: const Icon(LucideIcons.x),
          onPressed: windowManager.close,
        ),
      ],
    );
  }
}
