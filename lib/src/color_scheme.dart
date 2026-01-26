import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:shadcn/src/colors.dart';

enum BaseTone {
  neutral(TWColors.neutral),
  stone(TWColors.stone),
  zinc(TWColors.zinc),
  gray(TWColors.gray);

  const BaseTone(this.palette);

  final TWColor palette;
}

enum AccentColor {
  base(null),
  amber(TWColors.amber),
  blue(TWColors.blue),
  cyan(TWColors.cyan),
  emerald(TWColors.emerald),
  fuchsia(TWColors.fuchsia),
  green(TWColors.green),
  indigo(TWColors.indigo),
  lime(TWColors.lime),
  orange(TWColors.orange),
  pink(TWColors.pink);

  const AccentColor(this.palette);

  final TWColor? palette;
}

@immutable
class ColorScheme {
  const ColorScheme({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.border,
    required this.input,
    required this.ring,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarAccent,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarRing,
  });

  factory ColorScheme.from({
    required Brightness brightness,
    required BaseTone baseTone,
    required AccentColor accentColor,
  }) {
    final colorScheme = ColorScheme._palette(
      baseTone.palette,
      brightness == Brightness.dark,
    );

    if (accentColor.palette == null) return colorScheme;

    return colorScheme.copyWith(
      primary: accentColor.palette!.shade600,
      primaryForeground: accentColor.palette!.shade50,
    );
  }

  ColorScheme._palette(TWColor palette, bool isDark)
    : background = isDark ? palette.shade950 : TWColors.white,
      foreground = isDark ? palette.shade50 : palette.shade950,
      card = isDark ? palette.shade900 : TWColors.white,
      cardForeground = isDark ? palette.shade50 : palette.shade950,
      popover = isDark ? palette.shade900 : TWColors.white,
      popoverForeground = isDark ? palette.shade50 : palette.shade950,
      primary = isDark ? palette.shade200 : palette.shade900,
      primaryForeground = isDark ? palette.shade900 : palette.shade50,
      secondary = isDark ? palette.shade800 : palette.shade100,
      secondaryForeground = isDark ? palette.shade50 : palette.shade900,
      muted = isDark ? palette.shade800 : palette.shade100,
      mutedForeground = isDark ? palette.shade400 : palette.shade500,
      accent = isDark ? palette.shade800 : palette.shade100,
      accentForeground = isDark ? palette.shade50 : palette.shade900,
      destructive = isDark ? TWColors.red.shade400 : TWColors.red.shade600,
      border = isDark
          ? TWColors.white.withValues(alpha: 0.1)
          : palette.shade200,
      input = isDark
          ? TWColors.white.withValues(alpha: 0.05)
          : palette.shade400,
      ring = isDark ? palette.shade500 : palette.shade950,
      chart1 = isDark ? TWColors.blue.shade700 : TWColors.orange.shade600,
      chart2 = isDark ? TWColors.emerald.shade500 : TWColors.teal.shade600,
      chart3 = isDark ? TWColors.amber.shade500 : TWColors.cyan.shade900,
      chart4 = isDark ? TWColors.purple.shade500 : TWColors.amber.shade400,
      chart5 = isDark ? TWColors.rose.shade500 : TWColors.amber.shade500,
      sidebar = isDark ? palette.shade900 : palette.shade50,
      sidebarForeground = isDark ? palette.shade50 : palette.shade950,
      sidebarPrimary = isDark ? TWColors.blue.shade700 : palette.shade900,
      sidebarPrimaryForeground = isDark ? palette.shade50 : palette.shade50,
      sidebarAccent = isDark ? palette.shade800 : palette.shade100,
      sidebarAccentForeground = isDark ? palette.shade50 : palette.shade900,
      sidebarBorder = isDark
          ? TWColors.white.withValues(alpha: 0.1)
          : palette.shade200,
      sidebarRing = isDark ? palette.shade500 : palette.shade400;

  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color border;
  final Color input;
  final Color ring;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarPrimary;
  final Color sidebarPrimaryForeground;
  final Color sidebarAccent;
  final Color sidebarAccentForeground;
  final Color sidebarBorder;
  final Color sidebarRing;

  ColorScheme copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? border,
    Color? input,
    Color? ring,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Color? sidebar,
    Color? sidebarForeground,
    Color? sidebarPrimary,
    Color? sidebarPrimaryForeground,
    Color? sidebarAccent,
    Color? sidebarAccentForeground,
    Color? sidebarBorder,
    Color? sidebarRing,
  }) {
    return ColorScheme(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
      sidebar: sidebar ?? this.sidebar,
      sidebarForeground: sidebarForeground ?? this.sidebarForeground,
      sidebarPrimary: sidebarPrimary ?? this.sidebarPrimary,
      sidebarPrimaryForeground:
          sidebarPrimaryForeground ?? this.sidebarPrimaryForeground,
      sidebarAccent: sidebarAccent ?? this.sidebarAccent,
      sidebarAccentForeground:
          sidebarAccentForeground ?? this.sidebarAccentForeground,
      sidebarBorder: sidebarBorder ?? this.sidebarBorder,
      sidebarRing: sidebarRing ?? this.sidebarRing,
    );
  }
}
