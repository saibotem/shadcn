import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn/src/scrollbar.dart';
import 'package:shadcn/src/theme.dart';
import 'package:window_manager/window_manager.dart';

enum ThemeMode { system, light, dark }

class ShadcnApp extends StatefulWidget {
  const ShadcnApp({
    super.key,
    this.navigatorKey,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.initialRoute,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.builder,
    this.title,
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeResolutionCallback,
    this.localeListResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowWidgetInspector = false,
    this.debugShowCheckedModeBanner = false,
    this.exitWidgetSelectionButtonBuilder,
    this.moveExitWidgetSelectionButtonBuilder,
    this.tapBehaviorButtonBuilder,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
  }) : routeInformationProvider = null,
       routeInformationParser = null,
       routerDelegate = null,
       routerConfig = null,
       backButtonDispatcher = null;

  const ShadcnApp.router({
    super.key,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.onNavigationNotification,
    this.builder,
    this.title,
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeResolutionCallback,
    this.localeListResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowWidgetInspector = false,
    this.debugShowCheckedModeBanner = false,
    this.exitWidgetSelectionButtonBuilder,
    this.moveExitWidgetSelectionButtonBuilder,
    this.tapBehaviorButtonBuilder,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
  }) : navigatorKey = null,
       onGenerateRoute = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       navigatorObservers = null,
       initialRoute = null,
       home = null,
       routes = null;

  final GlobalKey<NavigatorState>? navigatorKey;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final NotificationListenerCallback<NavigationNotification>?
  onNavigationNotification;
  final List<NavigatorObserver>? navigatorObservers;
  final String? initialRoute;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final TransitionBuilder? builder;
  final String? title;
  final GenerateAppTitle? onGenerateTitle;
  final Color? color;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleResolutionCallback? localeResolutionCallback;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final bool debugShowWidgetInspector;
  final bool debugShowCheckedModeBanner;
  final ExitWidgetSelectionButtonBuilder? exitWidgetSelectionButtonBuilder;
  final MoveExitWidgetSelectionButtonBuilder?
  moveExitWidgetSelectionButtonBuilder;
  final TapBehaviorButtonBuilder? tapBehaviorButtonBuilder;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;

  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final RouterConfig<Object>? routerConfig;
  final BackButtonDispatcher? backButtonDispatcher;

  @override
  State<ShadcnApp> createState() => _ShadcnAppState();
}

class _ShadcnAppState extends State<ShadcnApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeWindowManager();
  }

  Future<void> _initializeWindowManager() async {
    if (!(Platform.isWindows || Platform.isMacOS || Platform.isLinux)) return;
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {});
  }

  bool get _usesRouter =>
      widget.routerDelegate != null || widget.routerConfig != null;

  ThemeData _themeBuilder(BuildContext context) {
    ThemeData? themeData;

    final brightness = MediaQuery.platformBrightnessOf(context);
    final useDarkTheme =
        widget.themeMode == ThemeMode.dark ||
        (widget.themeMode == ThemeMode.system && brightness == Brightness.dark);

    if (useDarkTheme) themeData = widget.darkTheme ?? ThemeData.dark();
    themeData ??= widget.theme ?? ThemeData.light();

    SystemChrome.setSystemUIOverlayStyle(
      brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );

    return themeData;
  }

  Widget _shadcnBuilder(BuildContext context, Widget? child, ThemeData theme) {
    var childWidget = child ?? const SizedBox.shrink();
    if (widget.builder != null) childWidget = widget.builder!(context, child);
    return ShadcnTheme(
      data: theme,
      child: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox.shrink();
          }
          return childWidget;
        },
      ),
    );
  }

  Widget _buildWidgetApp(BuildContext context, ThemeData theme) {
    if (_usesRouter) {
      return WidgetsApp.router(
        routeInformationProvider: widget.routeInformationProvider,
        routeInformationParser: widget.routeInformationParser,
        routerDelegate: widget.routerDelegate,
        routerConfig: widget.routerConfig,
        backButtonDispatcher: widget.backButtonDispatcher,
        builder: (context, child) => _shadcnBuilder(context, child, theme),
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        onNavigationNotification: widget.onNavigationNotification,
        textStyle: theme.textTheme.body,
        color: theme.colorScheme.primary,
        locale: widget.locale,
        localizationsDelegates: widget.localizationsDelegates,
        localeListResolutionCallback: widget.localeListResolutionCallback,
        localeResolutionCallback: widget.localeResolutionCallback,
        supportedLocales: widget.supportedLocales,
        showPerformanceOverlay: widget.showPerformanceOverlay,
        showSemanticsDebugger: widget.showSemanticsDebugger,
        debugShowWidgetInspector: widget.debugShowWidgetInspector,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        exitWidgetSelectionButtonBuilder:
            widget.exitWidgetSelectionButtonBuilder,
        moveExitWidgetSelectionButtonBuilder:
            widget.moveExitWidgetSelectionButtonBuilder,
        tapBehaviorButtonBuilder: widget.tapBehaviorButtonBuilder,
        shortcuts: widget.shortcuts,
        actions: widget.actions,
        restorationScopeId: widget.restorationScopeId,
      );
    }

    return WidgetsApp(
      navigatorKey: widget.navigatorKey,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      onNavigationNotification: widget.onNavigationNotification,
      navigatorObservers: widget.navigatorObservers!,
      initialRoute: widget.initialRoute,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: widget.home,
      routes: widget.routes!,
      builder: (context, child) => _shadcnBuilder(context, child, theme),
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      textStyle: theme.textTheme.body,
      color: theme.colorScheme.primary,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      localeResolutionCallback: widget.localeResolutionCallback,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      supportedLocales: widget.supportedLocales,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      debugShowWidgetInspector: widget.debugShowWidgetInspector,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      exitWidgetSelectionButtonBuilder: widget.exitWidgetSelectionButtonBuilder,
      moveExitWidgetSelectionButtonBuilder:
          widget.moveExitWidgetSelectionButtonBuilder,
      tapBehaviorButtonBuilder: widget.tapBehaviorButtonBuilder,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themeBuilder(context);
    return ScrollConfiguration(
      behavior: widget.scrollBehavior ?? const ShadcnScrollBehavior(),
      child: _buildWidgetApp(context, theme),
    );
  }
}

class ShadcnScrollBehavior extends ScrollBehavior {
  const ShadcnScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    switch (details.direction) {
      case AxisDirection.up:
      case AxisDirection.down:
        return Scrollbar.vertical(
          controller: details.controller,
          child: child,
        );
      case AxisDirection.right:
      case AxisDirection.left:
        return Scrollbar.horizontal(
          controller: details.controller,
          child: child,
        );
    }
  }
}
