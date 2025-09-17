import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:renote/models/note.dart';
import 'package:renote/providers/note_provider.dart';
import 'package:renote/util.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final QuillController _noteController = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  bool isArchive = false;
  bool isPinned = false;

  void _saveNote() {
    if (_titleController.text.isEmpty && _noteController.document.isEmpty()) {
      return;
    }
    if (widget.note == null) {
      Provider.of<NoteProvider>(context, listen: false)
          .addNote(
            _titleController.text,
            jsonEncode(_noteController.document.toDelta().toJson()),
          )
          .then((value) => showSnack('Note Saved', context));
    } else {
      Provider.of<NoteProvider>(context, listen: false)
          .updateNote(
            widget.note!.id,
            _titleController.text,
            jsonEncode(_noteController.document.toDelta().toJson()),
            isPinned,
            isArchive,
          )
          .then((value) => showSnack('Note Updated', context));
    }
    Provider.of<NoteProvider>(context, listen: false).loadNotes();
  }

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _noteController.document = Document.fromJson(
        jsonDecode(widget.note!.content),
      );
      setState(() {
        isPinned = widget.note!.pinned;
        isArchive = widget.note!.archived;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => _saveNote(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton.filledTonal(
              icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              onPressed: () => setState(() => isPinned = !isPinned),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            IconButton.filledTonal(
              icon: Icon(isArchive ? Icons.archive : Icons.archive_outlined),
              onPressed: () => setState(() => isArchive = !isArchive),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
              ),
              Expanded(
                child: QuillEditor.basic(
                  controller: _noteController,
                  config: QuillEditorConfig(
                    autoFocus: widget.note == null,
                    placeholder: 'Note',
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    QuillSimpleToolbar(
                      controller: _noteController,
                      config: const QuillSimpleToolbarConfig(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
