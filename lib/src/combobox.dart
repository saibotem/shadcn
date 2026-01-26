import 'package:flutter/widgets.dart';
import 'package:shadcn/src/button.dart';
import 'package:shadcn/src/card.dart';
import 'package:shadcn/src/icon_button.dart';
import 'package:shadcn/src/input.dart';
import 'package:shadcn/src/lucide_icons.dart';

class ComboboxController<T> extends ValueNotifier<T?> {
  ComboboxController({T? initialValue}) : super(initialValue);
}

class Combobox<T> extends StatefulWidget {
  const Combobox({
    required this.entries,
    required this.controller,
    required this.entryBuilder,
    super.key,
    this.hintLabel,
  });

  final List<T> entries;
  final String? hintLabel;
  final String Function(T value) entryBuilder;
  final ComboboxController<T> controller;

  @override
  State<Combobox<T>> createState() => _ComboboxState<T>();
}

class _ComboboxState<T> extends State<Combobox<T>> {
  final _menuController = MenuController();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _updateText();
    widget.controller.addListener(_updateText);
  }

  @override
  void dispose() {
    _textController.dispose();
    widget.controller.removeListener(_updateText);
    super.dispose();
  }

  void _updateText() {
    final value = widget.controller.value;
    _textController.text = value != null ? widget.entryBuilder(value) : '';
  }

  @override
  Widget build(BuildContext context) {
    return RawMenuAnchor(
      controller: _menuController,
      builder: (context, controller, _) {
        return Input(
          readOnly: true,
          onTap: _menuController.open,
          hintLabel: widget.hintLabel,
          controller: _textController,
          suffix: IconButton.ghost(
            onPressed: () => !controller.isOpen
                ? _menuController.open()
                : _menuController.close(),
            icon: controller.isOpen
                ? const Icon(LucideIcons.x, size: 20)
                : const Icon(LucideIcons.chevronDown, size: 20),
          ),
        );
      },
      overlayBuilder: (context, info) {
        return Positioned(
          left: info.anchorRect.left,
          top: info.anchorRect.bottom + 8,
          width: info.anchorRect.width,
          child: TapRegion(
            groupId: info.tapRegionGroupId,
            onTapOutside: (event) => _menuController.close(),
            child: Card(
              constraints: const BoxConstraints(maxHeight: 232),
              borderRadius: 8,
              padding: const EdgeInsets.all(8),
              child: _SelectOverlay(
                entries: widget.entries,
                controller: widget.controller,
                entryBuilder: widget.entryBuilder,
                onClose: _menuController.close,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectOverlay<T> extends StatefulWidget {
  const _SelectOverlay({
    required this.entries,
    required this.controller,
    required this.entryBuilder,
    required this.onClose,
  });

  final List<T> entries;
  final VoidCallback onClose;
  final ComboboxController<T> controller;
  final String Function(T value) entryBuilder;

  @override
  State<_SelectOverlay<T>> createState() => _SelectOverlayState<T>();
}

class _SelectOverlayState<T> extends State<_SelectOverlay<T>> {
  static const double _itemHeight = 33;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    final selectedIndex =
        widget.entries.indexOf(widget.controller.value as T) - 2;
    final initialOffset = selectedIndex > -1
        ? (selectedIndex * _itemHeight)
        : 0.0;

    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: false),
      child: ListView.builder(
        shrinkWrap: true,
        itemExtent: _itemHeight,
        controller: _scrollController,
        itemCount: widget.entries.length,
        itemBuilder: (context, index) {
          final entrie = widget.entries[index];
          return Button.ghost(
            onPressed: () {
              widget.controller.value = entrie;
              widget.onClose();
            },
            iconSuffix: entrie == widget.controller.value
                ? const Icon(LucideIcons.check)
                : null,
            label: Text(widget.entryBuilder(entrie)),
          );
        },
      ),
    );
  }
}
