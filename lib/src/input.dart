import 'package:flutter/widgets.dart';
import 'package:shadcn/src/colors.dart';
import 'package:shadcn/src/scrollbar.dart';
import 'package:shadcn/src/theme.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    this.onTap,
    this.prefix,
    this.suffix,
    this.hintLabel,
    this.controller,
    this.maxLines = 1,
    this.disabled = false,
    this.readOnly = false,
    this.destructive = false,
    this.obscureText = false,
  });

  final bool disabled;
  final bool readOnly;
  final bool destructive;
  final bool obscureText;

  final int maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final String? hintLabel;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final _focusNode = FocusNode();
  late final TextEditingController _controller;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.canRequestFocus = !widget.disabled;
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    _focusNode.canRequestFocus = !widget.disabled;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme.body;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!widget.disabled) {
          _focusNode.requestFocus();
          widget.onTap?.call();
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: widget.disabled ? 0.5 : 1,
        child: ListenableBuilder(
          listenable: _focusNode,
          builder: (context, child) {
            final shadowColor = switch ((
              widget.destructive,
              _focusNode.hasFocus,
            )) {
              (true, true) => colorScheme.destructive.withValues(alpha: 0.6),
              (false, true) => colorScheme.ring.withValues(alpha: 0.6),
              (_, false) => TWColors.transparent,
            };

            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                AnimatedContainer(
                  height: 21.0 * widget.maxLines + 19,
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    border: Border.all(color: shadowColor, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedContainer(
                  height: 21.0 * widget.maxLines + 15,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    color: colorScheme.input,
                    border: Border.all(
                      color: widget.destructive
                          ? colorScheme.destructive.withValues(alpha: 0.6)
                          : colorScheme.border,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: child,
                ),
              ],
            );
          },
          child: Row(
            children: [
              const SizedBox(width: 3),
              ?widget.prefix,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9, 7.5, 0, 7.5),
                  child: Stack(
                    children: [
                      if (widget.hintLabel != null)
                        ListenableBuilder(
                          listenable: _controller,
                          builder: (BuildContext context, Widget? child) {
                            return Visibility(
                              visible: _controller.text.isEmpty,
                              child: child!,
                            );
                          },
                          child: Text(
                            widget.hintLabel!,
                            style: textStyle.copyWith(
                              color: colorScheme.mutedForeground,
                            ),
                          ),
                        ),
                      Scrollbar.vertical(
                        controller: scrollController,
                        padding: const EdgeInsets.only(right: 4),
                        child: EditableText(
                          scrollBehavior: ScrollConfiguration.of(
                            context,
                          ).copyWith(scrollbars: false),
                          scrollController: scrollController,
                          cursorWidth: 1,
                          cursorHeight: textStyle.fontSize,
                          style: textStyle,
                          focusNode: _focusNode,
                          controller: _controller,
                          maxLines: widget.maxLines,
                          readOnly: widget.readOnly,
                          rendererIgnoresPointer: true,
                          obscureText: widget.obscureText,
                          cursorColor: colorScheme.foreground,
                          backgroundCursorColor: colorScheme.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ?widget.suffix,
              const SizedBox(width: 3),
            ],
          ),
        ),
      ),
    );
  }
}
