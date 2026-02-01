import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:shadcn/src/colors.dart';
import 'package:shadcn/src/theme.dart';

void showSheet({required BuildContext context, required Widget child}) {
  showGeneralDialog(
    context: context,
    barrierColor: TWColors.transparent,
    useRootNavigator: false,
    pageBuilder: (context, _, _) {
      final theme = ShadcnTheme.of(context);
      final colorScheme = theme.colorScheme;

      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 400,
          height: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.sidebar,
            border: Border(left: BorderSide(color: colorScheme.border)),
          ),
          child: child,
        ),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      return Stack(
        children: [
          FadeTransition(
            opacity: animation,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: ColoredBox(
                  color: TWColors.black.withValues(alpha: .1),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ],
      );
    },
  );
}
