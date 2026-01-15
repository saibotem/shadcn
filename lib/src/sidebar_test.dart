import 'package:flutter/material.dart';

// =============================================================================
// 1. DATA MODELS (Sealed Classes for Type Safety)
// =============================================================================

/// Die Basis-Klasse für alle Elemente in der NavigationRail.
sealed class RailEntry {
  const RailEntry();
}

/// Eine nicht-interaktive Überschrift zur Gruppierung.
/// Verbraucht KEINEN Index im Routing.
class RailHeader extends RailEntry {
  final String title;
  const RailHeader(this.title);
}

/// Ein klickbares Navigationselement mit optionalen Unterelementen.
/// Verbraucht IMMER einen Index (auch wenn eingeklappt).
class RailItem extends RailEntry {
  final String label;
  final IconData icon;
  final List<RailItem>? children;

  const RailItem({
    required this.label,
    required this.icon,
    this.children,
  });
}

// =============================================================================
// 2. STYLE CONFIGURATION (Clean Parameter Object)
// =============================================================================

class RailStyle {
  final double width;
  final EdgeInsets padding;
  final double itemHeight;
  
  // Colors (nullable -> fallback to Theme)
  final Color? backgroundColor;
  final Color? activeColor;      // Text & Icon wenn aktiv
  final Color? activeBackground; // Hintergrund "Pille" wenn aktiv
  final Color? inactiveColor;
  
  // Text Styles
  final TextStyle? labelStyle;
  final TextStyle? headerStyle;

  const RailStyle({
    this.width = 250,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.itemHeight = 48,
    this.backgroundColor,
    this.activeColor,
    this.activeBackground,
    this.inactiveColor,
    this.labelStyle,
    this.headerStyle,
  });
}

// =============================================================================
// 3. THE WIDGET (Logic & Rendering)
// =============================================================================

class CustomNavigationRail extends StatefulWidget {
  final List<RailEntry> entries;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final RailStyle style;

  const CustomNavigationRail({
    super.key,
    required this.entries,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.style = const RailStyle(),
  });

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  // Speichert die Indizes der ausgeklappten Items
  final Set<int> _expandedIndices = {};
  
  // Interner Zähler für die Index-Vergabe (Routing-Kompatibilität)
  int _recursiveCounter = 0;

  void _toggleGroup(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Theme Defaults abrufen (Flutter Way: Use Context)
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool useM3 = theme.useMaterial3;

    // 2. Effektive Styles berechnen
    final bgColor = widget.style.backgroundColor ?? colorScheme.surface;
    final activeColor = widget.style.activeColor ?? colorScheme.primary;
    // M3 nutzt PrimaryContainer, M2 nutzt Primary mit Opacity
    final activeBg = widget.style.activeBackground ?? 
        (useM3 ? colorScheme.secondaryContainer : colorScheme.primary.withOpacity(0.1));
    final inactiveColor = widget.style.inactiveColor ?? colorScheme.onSurfaceVariant;
    
    // 3. Reset Counter & Build List
    _recursiveCounter = 0;
    final List<Widget> uiNodes = [];

    for (var entry in widget.entries) {
      _buildNodeRecursive(
        entry: entry,
        depth: 0,
        output: uiNodes,
        activeColor: activeColor,
        activeBg: activeBg,
        inactiveColor: inactiveColor,
        useM3: useM3,
      );
    }

    // 4. Render
    return Container(
      width: widget.style.width,
      color: bgColor,
      // SingleChildScrollView verhindert Crash bei kleinen Fenstern (Safety)
      child: SingleChildScrollView(
        child: Padding(
          padding: widget.style.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: uiNodes,
          ),
        ),
      ),
    );
  }

  void _buildNodeRecursive({
    required RailEntry entry,
    required int depth,
    required List<Widget> output,
    required Color activeColor,
    required Color activeBg,
    required Color inactiveColor,
    required bool useM3,
  }) {
    // --- CASE A: HEADER ---
    if (entry is RailHeader) {
      output.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            entry.title.toUpperCase(),
            style: widget.style.headerStyle ?? TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: inactiveColor.withOpacity(0.6),
              letterSpacing: 1.0,
            ),
          ),
        ),
      );
      return;
    }

    // --- CASE B: ITEM ---
    if (entry is RailItem) {
      final int myIndex = _recursiveCounter++; // Zähler erhöhen!
      
      final bool isSelected = widget.selectedIndex == myIndex;
      final bool hasChildren = entry.children != null && entry.children!.isNotEmpty;
      final bool isExpanded = _expandedIndices.contains(myIndex);
      
      // Indentation (Einrückung)
      final double paddingLeft = 12.0 + (depth * 12.0);

      // Best Practice: Semantics für Screenreader
      final Widget itemWidget = Semantics(
        selected: isSelected,
        button: true,
        label: entry.label,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Material(
            color: isSelected ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(useM3 ? 12 : 4), // M3 = runder
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => widget.onDestinationSelected(myIndex),
              child: Container(
                height: widget.style.itemHeight,
                padding: EdgeInsets.only(left: paddingLeft, right: 8.0),
                child: Row(
                  children: [
                    Icon(
                      entry.icon,
                      size: 20,
                      color: isSelected ? activeColor : inactiveColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.label,
                        style: widget.style.labelStyle?.copyWith(
                          color: isSelected ? activeColor : inactiveColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ) ?? TextStyle(
                          fontSize: 14,
                          color: isSelected ? activeColor : inactiveColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Toggle Button für Kinder
                    if (hasChildren)
                      Material(
                        type: MaterialType.transparency,
                        child: InkResponse(
                          radius: 16,
                          // Wichtig: Klick hier ändert NICHT die Selektion, nur Expand
                          onTap: () => _toggleGroup(myIndex),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              size: 18,
                              color: inactiveColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      output.add(itemWidget);

      // --- KINDER VERARBEITUNG ---
      if (hasChildren) {
        if (isExpanded) {
          // Rekursiver Aufruf: UI bauen
          for (var sub in entry.children!) {
            _buildNodeRecursive(
              entry: sub,
              depth: depth + 1,
              output: output,
              activeColor: activeColor,
              activeBg: activeBg,
              inactiveColor: inactiveColor,
              useM3: useM3,
            );
          }
        } else {
          // WICHTIG: UI überspringen, aber Zähler weiterlaufen lassen!
          // Damit bleiben Indizes stabil für GoRouter/IndexedStack
          _skipNodeRecursive(entry.children!);
        }
      }
    }
  }

  /// Zählt Indizes virtuell hoch, ohne Widgets zu erzeugen.
  void _skipNodeRecursive(List<RailItem> items) {
    for (var item in items) {
      _recursiveCounter++;
      if (item.children != null) {
        _skipNodeRecursive(item.children!);
      }
    }
  }
}

// =============================================================================
// 4. EXAMPLE USAGE
// =============================================================================

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  // Der State für den aktuellen Tab. In GoRouter wäre das der shell.currentIndex
  int _selectedIndex = 0;

  // --- Konfiguration (Intuitiv & Sauber) ---
  final List<RailEntry> _menu = [
    // Index 0
    const RailItem(label: 'Dashboard', icon: Icons.dashboard),
    
    // Header (Kein Index)
    const RailHeader('Verwaltung'),
    
    // Parent ist Index 1
    const RailItem(
      label: 'Benutzer', 
      icon: Icons.people,
      children: [
        RailItem(label: 'Liste', icon: Icons.list),       // Index 2
        RailItem(label: 'Erstellen', icon: Icons.person_add), // Index 3
      ]
    ),
    
    // Header (Kein Index)
    const RailHeader('System'),
    
    // Index 4 (Bleibt Index 4, auch wenn "Benutzer" zugeklappt ist!)
    const RailItem(label: 'Einstellungen', icon: Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Die performante Rail
          CustomNavigationRail(
            entries: _menu,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (idx) {
              setState(() => _selectedIndex = idx);
              // Hier würde stehen: navigationShell.goBranch(idx);
            },
            // Optional: Styling anpassen
            style: RailStyle(
              width: 260,
              backgroundColor: Colors.grey[50], // Heller Hintergrund
              // Automatische Anpassung an DarkMode durch Weglassen von Hardcoded Colors möglich
            ),
          ),
          
          const VerticalDivider(width: 1),
          
          // Der Inhalt (Simulation von IndexedStack)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Content Area', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  Text(
                    'Selected Index: $_selectedIndex',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '(Probier das Einklappen der Gruppe "Benutzer".\nDer Index von "Einstellungen" bleibt stabil auf 4.)',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}