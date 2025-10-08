import 'package:flutter/material.dart';

void main() {
  runApp(const WriteakApp());
}

class WriteakApp extends StatelessWidget {
  const WriteakApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Writeak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScaffoldWithSidebar(),
    );
  }
}

class ScaffoldWithSidebar extends StatefulWidget {
  const ScaffoldWithSidebar({Key? key}) : super(key: key);

  @override
  State<ScaffoldWithSidebar> createState() => _ScaffoldWithSidebarState();
}

class _ScaffoldWithSidebarState extends State<ScaffoldWithSidebar> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _items = const [
    _NavItem(icon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.note, label: 'Notes'),
    _NavItem(icon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLarge = constraints.maxWidth >= 800;

        return Scaffold(
          key: _scaffoldKey,
          drawer: isLarge ? null : Drawer(child: _buildSidebar()),
          body: Row(
            children: [
              if (isLarge) SizedBox(width: 240, child: _buildSidebar()),
              Expanded(child: _buildContent()),
            ],
          ),
          bottomNavigationBar: isLarge
              ? null
              : BottomNavigationBar(
                  items: _items
                      .map((it) => BottomNavigationBarItem(icon: Icon(it.icon), label: it.label))
                      .toList(),
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() => _selectedIndex = index);
                    // close drawer on selection if open (mobile)
                    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                      final scaffoldCtx = _scaffoldKey.currentContext;
                      if (scaffoldCtx != null) Navigator.of(scaffoldCtx).pop();
                    }
                  },
                ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Material(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            height: 140,
            color: Colors.blue,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: const Text('Writeak', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final selected = index == _selectedIndex;
                return ListTile(
                  leading: Icon(item.icon, color: selected ? Colors.blue : null),
                  title: Text(item.label),
                  selected: selected,
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    if (Scaffold.of(context).isDrawerOpen) Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('v0.1.0', style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _items[_selectedIndex].label,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              child: Center(
                child: Text('Content for "' + _items[_selectedIndex].label + '"'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
