
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renote/providers/note_provider.dart';
import 'package:renote/screens/archieve_screen.dart';
import 'package:renote/screens/deleted_screen.dart';
import 'package:renote/screens/note_editor_screen.dart';
import 'package:renote/screens/discover_screen.dart';
import 'package:renote/screens/notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final _navScreens = [
    NotesScreen(),
    DiscoverScreen(),
    ArchieveScreen(),
    DeletedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _navIndex == 0,
      onPopInvokedWithResult: (didPop, result) => setState(() => _navIndex = 0),
      child: Scaffold(
        drawer: NavigationDrawer(
          selectedIndex: _navIndex,
          onDestinationSelected: (value) {
            setState(() => _navIndex = value);
            Navigator.pop(context);
          },
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          header: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Image.asset(
                  'assets/renote.png',
                  height: 20,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
          children: [
            NavigationDrawerDestination(
              icon: Icon(Icons.edit),
              label: Text('Notes'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.explore_outlined),
              label: Text('Discover'),
            ),
            Divider(),
            NavigationDrawerDestination(
              icon: Icon(Icons.archive_outlined),
              label: Text('Archive'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.delete_outline),
              label: Text('Deleted'),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<NoteProvider>(context, listen: false).loadNotes();
          },
          child: _navScreens[_navIndex],
        ),
        floatingActionButton: _navIndex != 0
            ? null
            : FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoteEditorScreen(),
                  ),
                ),
                child: Icon(Icons.add),
              ),
      ),
    );
  }
}
