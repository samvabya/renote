import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renote/components/note_card.dart';
import 'package:renote/providers/note_provider.dart';

class ArchieveScreen extends StatelessWidget {
  const ArchieveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, _) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(title: Text('Archive')),

            if (noteProvider.isLoading)
              SliverToBoxAdapter(child: LinearProgressIndicator())
            else
              SliverPadding(
                padding: EdgeInsetsGeometry.all(10),
                sliver: noteProvider.notesArchived.isEmpty
                    ? SliverFillRemaining(
                        child: Center(child: Text('You don\'t have any notes')),
                      )
                    : SliverList.builder(
                        itemCount: noteProvider.notesArchived.length,
                        itemBuilder: (context, index) {
                          var note = noteProvider.notesArchived[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: NoteCard(
                              note: note,
                              onLongPressStart: (details) {
                                final offset = details.globalPosition;
                                showMenu(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      20,
                                    ),
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
                                        false,
                                      ),
                                      value: 'unarchive',
                                      child: Text('Unarchive'),
                                    ),
                                  ],
                                );
                              },
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
