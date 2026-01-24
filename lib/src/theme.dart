import 'package:flutter/widgets.dart';
import 'package:shadcn/src/color_scheme.dart';
import 'package:shadcn/src/text_theme.dart';

const Duration kThemeAnimationDuration = Duration(milliseconds: 200);

class ShadcnTheme extends StatelessWidget {
  const ShadcnTheme({required this.data, required this.child, super.key});

  final ThemeData data;
  final Widget child;

  static ThemeData of(BuildContext context) {
    final inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<_InheritedTheme>()!;
    return inheritedTheme.theme.data;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      theme: this,
      child: IconTheme(
        data: data.iconTheme,
        child: DefaultSelectionStyle(
          cursorColor: data.colorScheme.foreground,
          selectionColor: data.colorScheme.secondary,
          child: child,
        ),
      ),
    );
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({required this.theme, required super.child});

  final ShadcnTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ShadcnTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedTheme old) => theme.data != old.theme.data;
}

@immutable
class ThemeData {
  factory ThemeData({
    Brightness brightness = Brightness.light,
    BaseTone baseTone = BaseTone.neutral,
    AccentColor accentColor = AccentColor.base,
  }) {
    final colorScheme = ColorScheme.from(
      brightness: brightness,
      baseTone: baseTone,
      accentColor: accentColor,
    );

    return ThemeData.raw(
      colorScheme: colorScheme,
      iconTheme: IconThemeData(
        size: 16,
        color: colorScheme.foreground,
        opticalSize: 1,
      ),
      textTheme: TextThemeData(color: colorScheme.foreground),
    );
  }

  factory ThemeData.light({
    BaseTone baseTone = BaseTone.neutral,
    AccentColor accentColor = AccentColor.base,
  }) {
    return ThemeData(
      baseTone: baseTone,
      accentColor: accentColor,
    );
  }

  factory ThemeData.dark({
    BaseTone baseTone = BaseTone.neutral,
    AccentColor accentColor = AccentColor.base,
  }) {
    return ThemeData(
      brightness: Brightness.dark,
      baseTone: baseTone,
      accentColor: accentColor,
    );
  }

  const ThemeData.raw({
    required this.colorScheme,
    required this.iconTheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final IconThemeData iconTheme;
  final TextThemeData textTheme;
}

extension TextStyleExtension on TextStyle {
  TextStyle withColor(Color? color) {
    return copyWith(color: color);
  }
}
