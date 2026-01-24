import 'package:shadcn/shadcn.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnApp(
      home: Navigator(),
    );
  }
}

class Navigator extends StatefulWidget {
  const Navigator({super.key});

  @override
  State<Navigator> createState() => _NavigatorState();
}

class _NavigatorState extends State<Navigator> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Sidebar(
      content:  Center(child: Text('$selectedIndex'),),
      destinations: const [
        SidebarLabel(label: Text('Getting Started')),
        SidebarButton(label: Text('Installation')),
        SidebarButton(label: Text('Project Structure')),
        SidebarLabel(label: Text('Platform')),
        SidebarButton(
          icon: Icon(LucideIcons.squareTerminal),
          label: Text('Playground'),
          subButtons: [
            SidebarSubButton(label: Text('History')),
            SidebarSubButton(label: Text('Starred')),
            SidebarSubButton(label: Text('Settings')),
          ],
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (int value) {
        setState(() => selectedIndex = value);
      },
    );
  }
}
