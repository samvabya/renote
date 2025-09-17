import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:renote/providers/note_provider.dart';
import 'package:renote/screens/archieve_screen.dart';
import 'package:renote/screens/deleted_screen.dart';
import 'package:renote/screens/note_editor_screen.dart';
import 'package:renote/screens/reminder_screen.dart';
import 'package:renote/util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final _navScreens = [
    NotesScreen(),
    ReminderScreen(),
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
              icon: Icon(Icons.note_alt),
              label: Text('Notes'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.alarm),
              label: Text('Reminder'),
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

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, _) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              toolbarHeight: 70,
              title: Container(
                height: 60,
                padding: const EdgeInsets.only(left: 20, right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/renote.png',
                      width: 60,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.swap_vert)),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 18,
                    child: Icon(Icons.person, size: 18),
                  ),
                ),
              ],
            ),
            if (noteProvider.isLoading)
              SliverToBoxAdapter(child: LinearProgressIndicator())
            else
              SliverPadding(
                padding: EdgeInsetsGeometry.all(10),
                sliver: noteProvider.notes.isEmpty
                    ? SliverFillRemaining(
                        child: Center(child: Text('You don\'t have any notes')),
                      )
                    : SliverList.builder(
                        itemCount: noteProvider.notesDefault.length,
                        itemBuilder: (context, index) {
                          var note = noteProvider.notesDefault[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Dismissible(
                              key: Key(note.id),
                              onDismissed: (direction) {
                                noteProvider.archiveNote(note.id, true);
                                showSnack('Note archived', context);
                              },
                              child: Stack(
                                children: [
                                  if (note.pinned)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Icon(Icons.push_pin),
                                    ),
                                  ListTile(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NoteEditorScreen(note: note),
                                      ),
                                    ),
                                    title: Text(note.title),
                                    subtitle: Text(
                                      (Document.fromJson(
                                        jsonDecode(note.content),
                                      )).toPlainText(),
                                    ),
                                    tileColor: Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        );
      },
    );
  }
}
