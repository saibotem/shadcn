import 'package:flutter/widgets.dart';
import 'package:shadcn/src/card.dart';
import 'package:shadcn/src/theme.dart';

class AlertDialog extends StatelessWidget {
  const AlertDialog({
    required this.title,
    required this.subtitle,
    super.key,
    this.icon,
    this.content,
  });

  final Icon? icon;
  final Text title;
  final Widget subtitle;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconTheme.merge(
                    data: const IconThemeData(size: 32),
                    child: icon!,
                  ),
                ),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(style: textTheme.titleLarge, child: title),
                  DefaultTextStyle(
                    style: textTheme.body.withColor(
                      colorScheme.mutedForeground,
                    ),
                    child: subtitle,
                  ),
                ],
              ),
            ],
          ),
          ?content,
        ],
      ),
    );
  }
}
