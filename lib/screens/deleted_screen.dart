import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renote/components/note_card.dart';
import 'package:renote/providers/note_provider.dart';

class DeletedScreen extends StatelessWidget {
  const DeletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, _) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(title: Text('Deleted')),

            if (noteProvider.isLoading)
              SliverToBoxAdapter(child: LinearProgressIndicator())
            else
              SliverPadding(
                padding: EdgeInsetsGeometry.all(10),
                sliver: noteProvider.notesDeleted.isEmpty
                    ? SliverFillRemaining(
                        child: Center(child: Text('Bin is empty')),
                      )
                    : SliverList.builder(
                        itemCount: noteProvider.notesDeleted.length,
                        itemBuilder: (context, index) {
                          var note = noteProvider.notesDeleted[index];

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
                                      onTap: () => noteProvider
                                          .deleteNotePermanent(note.id),
                                      value: 'delete',
                                      child: Text('Delete permanently'),
                                    ),
                                    PopupMenuItem(
                                      onTap: () => noteProvider.deleteNote(
                                        note.id,
                                        false,
                                      ),
                                      value: 'restore',
                                      child: Text('Restore'),
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
