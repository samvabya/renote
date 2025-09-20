import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renote/components/note_card.dart';
import 'package:renote/providers/note_provider.dart';
import 'package:renote/util.dart';

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
                padding: EdgeInsetsGeometry.all(15),
                sliver: noteProvider.notesDefault.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.surface,
                                    BlendMode.hue,
                                  ),
                                  child: Image.asset('assets/work.png'),
                                ),
                              ),
                              Text('You don\'t have any notes'),
                            ],
                          ),
                        ),
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
                              child: NoteCard(
                                note: note,
                                onLongPressStart: (details) {
                                  final offset = details.globalPosition;
                                  showMenu(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(20),
                                    ),
                                    position: RelativeRect.fromLTRB(
                                      offset.dx,
                                      offset.dy,
                                      MediaQuery.of(context).size.width -
                                          offset.dx,
                                      MediaQuery.of(context).size.height -
                                          offset.dy,
                                    ),
                                    items: [
                                      PopupMenuItem(
                                        onTap: () => noteProvider.deleteNote(
                                          note.id,
                                          true,
                                        ),
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                      PopupMenuItem(
                                        onTap: () => noteProvider.archiveNote(
                                          note.id,
                                          true,
                                        ),
                                        value: 'archive',
                                        child: Text('Archive'),
                                      ),
                                    ],
                                  );
                                },
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
