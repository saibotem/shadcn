library;

import 'package:flutter/widgets.dart';

import 'color_scheme.dart';
import 'text_theme.dart';

const Duration kThemeAnimationDuration = Duration(milliseconds: 200);

class ShadcnTheme extends StatelessWidget {
  const ShadcnTheme({super.key, required this.data, required this.child});

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
    AccentColor accentColor = AccentColor.base,
    BaseColor baseColor = BaseColor.neutral,
    Brightness brightness = Brightness.light,
    String? fontFamily,
  }) {
    final colorScheme = ColorScheme.from(
      brightness: brightness,
      baseColor: baseColor,
      accentColor: accentColor,
    );

    final textTheme = TextTheme.resolve(
      colorScheme: colorScheme,
      fontFamily: fontFamily,
    );

    final iconTheme = IconThemeData(color: colorScheme.foreground);

    return ThemeData.raw(
      colorScheme: colorScheme,
      iconTheme: iconTheme,
      textTheme: textTheme,
    );
  }

  factory ThemeData.light({
    AccentColor accentColor = AccentColor.base,
    BaseColor baseColor = BaseColor.neutral,
    String? fontFamily,
  }) {
    return ThemeData(
      accentColor: accentColor,
      baseColor: baseColor,
      brightness: Brightness.light,
      fontFamily: fontFamily,
    );
  }

  factory ThemeData.dark({
    AccentColor accentColor = AccentColor.base,
    BaseColor baseColor = BaseColor.neutral,
    String? fontFamily,
  }) {
    return ThemeData(
      accentColor: accentColor,
      baseColor: baseColor,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
    );
  }

  const ThemeData.raw({
    required this.colorScheme,
    required this.iconTheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final IconThemeData iconTheme;
}
