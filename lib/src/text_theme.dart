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
        overflow: TextOverflow.ellipsis,
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
        overflow: TextOverflow.ellipsis,
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
        overflow: TextOverflow.ellipsis,
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
        overflow: TextOverflow.ellipsis,
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
        overflow: TextOverflow.ellipsis,
      ),
      bodySmall: TextStyle(
        color: color,
        fontSize: 13,
        textBaseline: TextBaseline.alphabetic,
        height: 18 / 13,
        leadingDistribution: TextLeadingDistribution.even,
        fontVariations: const [FontVariation('wght', 300)],
        fontFamily: 'Inter',
        package: 'shadcn',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  const TextThemeData._({
    required this.titleLarge,
    required this.title,
    required this.labelMedium,
    required this.labelSmall,
    required this.body,
    required this.bodySmall,
  });

  final TextStyle titleLarge;
  final TextStyle title;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle body;
  final TextStyle bodySmall;
}
