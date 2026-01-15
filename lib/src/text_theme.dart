import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
class TextThemeData {
  factory TextThemeData({required Color color}) {
    return TextThemeData._(
      title: TextStyle(
        color: color,
        fontSize: 16,
        fontVariations: const [FontVariation('wght', 400)],
        textBaseline: TextBaseline.alphabetic,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
      labelMedium: TextStyle(
        color: color,
        fontSize: 14,
        fontVariations: const [FontVariation('wght', 400)],
        textBaseline: TextBaseline.alphabetic,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
      labelSmall: TextStyle(
        color: color,
        fontSize: 12,
        textBaseline: TextBaseline.alphabetic,
        leadingDistribution: TextLeadingDistribution.even,
        fontVariations: const [FontVariation('wght', 400)],
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
      body: TextStyle(
        color: color,
        fontSize: 14,
        textBaseline: TextBaseline.alphabetic,
        leadingDistribution: TextLeadingDistribution.even,
        fontVariations: const [FontVariation('wght', 300)],
        fontFamily: 'Inter',
        package: 'shadcn',
      ),
    );
  }

  const TextThemeData._({
    required this.title,
    required this.labelMedium,
    required this.labelSmall,
    required this.body,
  });

  final TextStyle title;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle body;
}
