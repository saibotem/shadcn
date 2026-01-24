import 'package:flutter/widgets.dart';
import 'package:shadcn/src/card.dart';
import 'package:shadcn/src/theme.dart';

typedef DropdownMenuButtonBuilder = RawMenuAnchorChildBuilder;

class DropdownMenu extends StatefulWidget {
  const DropdownMenu({
    required this.buttonBuilder,
    required this.items,
    super.key,
  });

  final DropdownMenuButtonBuilder buttonBuilder;
  final List<Widget> items;

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);

    return RawMenuAnchor(
      controller: _menuController,
      builder: widget.buttonBuilder,
      overlayBuilder: (BuildContext context, RawMenuOverlayInfo info) {
        return Positioned(
          left: info.anchorRect.left,
          top: info.anchorRect.bottom + 4,
          child: TapRegion(
            groupId: info.tapRegionGroupId,
            onTapOutside: (event) => _menuController.close(),
            child: Card(
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: DefaultTextStyle(
                style: theme.textTheme.body,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.items,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
