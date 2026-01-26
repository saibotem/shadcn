import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:shadcn/src/icon_button.dart';
import 'package:shadcn/src/lucide_icons.dart';
import 'package:shadcn/src/theme.dart';
import 'package:window_manager/window_manager.dart';

class WindowBar extends StatefulWidget {
  const WindowBar({super.key, this.prefixWidget, this.surfixWidget});

  final Widget? prefixWidget;
  final Widget? surfixWidget;

  @override
  State<WindowBar> createState() => _WindowBarState();
}

class _WindowBarState extends State<WindowBar> {
  bool _isWindowManagerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWindowManager();
  }

  Future<void> _initializeWindowManager() async {
    if (!(Platform.isWindows || Platform.isMacOS || Platform.isLinux)) return;
    await windowManager.ensureInitialized();
    _isWindowManagerInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return GestureDetector(
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
          border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
        ),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: widget.prefixWidget != null
                  ? widget.prefixWidget!
                  : const SizedBox.shrink(),
            ),
            ?widget.surfixWidget,
            const _WindowButtons(),
          ],
        ),
      ),
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
    _initWindowManager();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _initWindowManager() async {
    final isMaximized = await windowManager.isMaximized();
    setState(() => _isMaximized = isMaximized);
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
