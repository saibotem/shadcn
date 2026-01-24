import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
class TextThemeData {
  factory TextThemeData({required Color color}) {
    return TextThemeData._(
      titleLarge: TextStyle(
        color: color,
        fontSize: 18,
        fontVariations: const [FontVariation('wght', 400)],
        textBaseline: TextBaseline.alphabetic,
        height: 28 / 18,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
      title: TextStyle(
        color: color,
        fontSize: 16,
        fontVariations: const [FontVariation('wght', 400)],
        textBaseline: TextBaseline.alphabetic,
        height: 24 / 16,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
      labelMedium: TextStyle(
        color: color,
        fontSize: 14,
        fontVariations: const [FontVariation('wght', 400)],
        textBaseline: TextBaseline.alphabetic,
        height: 20 / 14,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
      labelSmall: TextStyle(
        color: color,
        fontSize: 12,
        textBaseline: TextBaseline.alphabetic,
        height: 16 / 12,
        leadingDistribution: TextLeadingDistribution.even,
        fontVariations: const [FontVariation('wght', 400)],
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
      body: TextStyle(
        color: color,
        fontSize: 14,
        textBaseline: TextBaseline.alphabetic,
        height: 20 / 14,
        leadingDistribution: TextLeadingDistribution.even,
        fontVariations: const [FontVariation('wght', 300)],
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
    );
  }

  const TextThemeData._({
    required this.titleLarge,
    required this.title,
    required this.labelMedium,
    required this.labelSmall,
    required this.body,
  });

  final TextStyle titleLarge;
  final TextStyle title;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle body;
}
