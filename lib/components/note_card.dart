import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:renote/models/note.dart';
import 'package:renote/screens/note_editor_screen.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final void Function(LongPressStartDetails)? onLongPressStart;
  const NoteCard({super.key, required this.note, this.onLongPressStart});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: onLongPressStart,
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteEditorScreen(note: note)),
        ),
        title: Text(note.title),
        subtitle: Text(
          (Document.fromJson(jsonDecode(note.content))).toPlainText(),
        ),
        tileColor: note.pinned
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
