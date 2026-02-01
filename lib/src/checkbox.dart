import 'package:flutter/widgets.dart';
import 'package:shadcn/src/lucide_icons.dart';
import 'package:shadcn/src/theme.dart';

class CheckboxController extends ValueNotifier<bool> {
  CheckboxController({bool initialValue = false}) : super(initialValue);

  void toggle() => value = !value;
}

class Checkbox extends StatelessWidget {
  const Checkbox({
    required this.controller,
    super.key,
    this.label,
    this.disabled = false,
  });

  final Text? label;
  final bool disabled;
  final CheckboxController controller;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled ? null : controller.toggle,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: disabled ? 0.5 : 1,
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: controller,
              builder: (_, isChecked, child) {
                return AnimatedContainer(
                  margin: const EdgeInsets.all(2),
                  duration: const Duration(milliseconds: 100),
                  constraints: BoxConstraints.tight(const Size.square(18)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: colorScheme.border),
                    color: isChecked ? colorScheme.primary : colorScheme.muted,
                  ),
                  child: AnimatedOpacity(
                    opacity: isChecked ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 100),
                    child: child,
                  ),
                );
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Icon(
                  size: 14,
                  LucideIcons.check,
                  color: colorScheme.primaryForeground,
                ),
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
