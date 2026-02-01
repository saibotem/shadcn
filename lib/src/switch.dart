import 'package:flutter/widgets.dart';
import 'package:shadcn/src/theme.dart';

class SwitchController extends ValueNotifier<bool> {
  SwitchController({bool initialValue = false}) : super(initialValue);

  void toggle() => value = !value;
}

class Switch extends StatelessWidget {
  const Switch({
    required this.controller,
    super.key,
    this.label,
    this.disabled = false,
  });

  final Text? label;
  final bool disabled;
  final SwitchController controller;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: disabled ? null : controller.toggle,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Row(
          spacing: 12,
          children: [
            MouseRegion(
              cursor: disabled
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              child: ValueListenableBuilder<bool>(
                valueListenable: controller,
                builder: (_, value, _) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 18,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: value ? colorScheme.primary : colorScheme.input,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: value
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: value
                              ? colorScheme.primaryForeground
                              : colorScheme.foreground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (label != null)
              DefaultTextStyle(
                style: theme.textTheme.body,
                child: label!,
              ),
          ],
        ),
      ),
    );
  }
}
