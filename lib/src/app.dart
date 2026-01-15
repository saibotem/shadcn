import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn/src/theme.dart';

enum ThemeMode { system, light, dark }

class ShadcnApp extends StatelessWidget {
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
    this.debugShowCheckedModeBanner = true,
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
    this.debugShowCheckedModeBanner = true,
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

  bool get _usesRouter => routerDelegate != null || routerConfig != null;

  ThemeData _themeBuilder(BuildContext context) {
    ThemeData? themeData;

    final brightness = MediaQuery.platformBrightnessOf(context);
    final useDarkTheme =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);

    if (useDarkTheme) themeData = darkTheme ?? ThemeData.dark();
    themeData ??= theme ?? ThemeData.light();

    SystemChrome.setSystemUIOverlayStyle(
      brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );

    return themeData;
  }

  Widget _shadcnBuilder(BuildContext context, Widget? child, ThemeData theme) {
    var childWidget = child ?? const SizedBox.shrink();
    if (builder != null) childWidget = builder!(context, child);
    return ShadcnTheme(data: theme, child: childWidget);
  }

  Widget _buildWidgetApp(BuildContext context, ThemeData theme) {
    if (_usesRouter) {
      return WidgetsApp.router(
        routeInformationProvider: routeInformationProvider,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
        routerConfig: routerConfig,
        backButtonDispatcher: backButtonDispatcher,
        builder: (context, child) => _shadcnBuilder(context, child, theme),
        title: title,
        onGenerateTitle: onGenerateTitle,
        onNavigationNotification: onNavigationNotification,
        textStyle: theme.textTheme.body,
        color: theme.colorScheme.primary,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowWidgetInspector: debugShowWidgetInspector,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        exitWidgetSelectionButtonBuilder: exitWidgetSelectionButtonBuilder,
        moveExitWidgetSelectionButtonBuilder:
            moveExitWidgetSelectionButtonBuilder,
        tapBehaviorButtonBuilder: tapBehaviorButtonBuilder,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
      );
    }

    return WidgetsApp(
      navigatorKey: navigatorKey,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      onNavigationNotification: onNavigationNotification,
      navigatorObservers: navigatorObservers!,
      initialRoute: initialRoute,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: home,
      routes: routes!,
      builder: (context, child) => _shadcnBuilder(context, child, theme),
      title: title,
      onGenerateTitle: onGenerateTitle,
      textStyle: theme.textTheme.body,
      color: theme.colorScheme.primary,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeResolutionCallback: localeResolutionCallback,
      localeListResolutionCallback: localeListResolutionCallback,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowWidgetInspector: debugShowWidgetInspector,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      exitWidgetSelectionButtonBuilder: exitWidgetSelectionButtonBuilder,
      moveExitWidgetSelectionButtonBuilder:
          moveExitWidgetSelectionButtonBuilder,
      tapBehaviorButtonBuilder: tapBehaviorButtonBuilder,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themeBuilder(context);
    return _buildWidgetApp(context, theme);
  }
}
