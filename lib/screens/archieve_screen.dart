import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:renote/providers/note_provider.dart';
import 'package:renote/screens/note_editor_screen.dart';

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
                            child: ListTile(
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
