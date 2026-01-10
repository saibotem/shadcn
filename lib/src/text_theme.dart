library;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'color_scheme.dart';

@immutable
class TextTheme {
  const TextTheme({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.p,
    required this.blockquote,
    required this.table,
    required this.list,
    required this.inlineCode,
    required this.lead,
    required this.large,
    required this.small,
    required this.muted,
  });

  factory TextTheme.resolve({
    required ColorScheme colorScheme,
    required String? fontFamily,
  }) {
    return TextTheme(
      h1: TextStyle(
        color: colorScheme.foreground,
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: 36 * -0.025,
        height: 2.5 / 2.25,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      h2: TextStyle(
        color: colorScheme.foreground,
        fontSize: 30,
        fontWeight: FontWeight.w600,
        letterSpacing: 30 * -0.025,
        height: 2.25 / 1.875,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      h3: TextStyle(
        color: colorScheme.foreground,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 24 * -0.025,
        height: 2 / 1.5,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      h4: TextStyle(
        color: colorScheme.foreground,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 20 * -0.025,
        height: 1.75 / 1.25,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      p: TextStyle(
        color: colorScheme.foreground,
        fontSize: 16,
        height: 7 * 0.25,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      blockquote: TextStyle(
        color: colorScheme.foreground,
        fontSize: 16,
        fontStyle: FontStyle.italic,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      table: TextStyle(
        color: colorScheme.foreground,
        fontSize: 16,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      list: TextStyle(
        color: colorScheme.foreground,
        fontSize: 16,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      inlineCode: TextStyle(
        color: colorScheme.foreground,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25 / 0.875,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      lead: TextStyle(
        color: colorScheme.mutedForeground,
        fontSize: 20,
        height: 1.75 / 1.25,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      large: TextStyle(
        color: colorScheme.foreground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.75 / 1.125,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      small: TextStyle(
        color: colorScheme.foreground,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
      muted: TextStyle(
        color: colorScheme.mutedForeground,
        fontSize: 14,
        height: 1.25 / 0.875,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: fontFamily,
      ),
    );
  }

  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle p;
  final TextStyle blockquote;
  final TextStyle table;
  final TextStyle list;
  final TextStyle inlineCode;
  final TextStyle lead;
  final TextStyle large;
  final TextStyle small;
  final TextStyle muted;
}
