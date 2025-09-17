import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../services/hive_service.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _notesPinned = [];
  List<Note> _notesDefault = [];
  List<Note> _notesArchived = [];
  List<Note> _notesDeleted = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  List<Note> get notesDefault => _notesDefault;
  List<Note> get notesArchived => _notesArchived;
  List<Note> get notesDeleted => _notesDeleted;
  bool get isLoading => _isLoading;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    _notes = HiveService.getAllNotes();
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // formatting
    _notesDeleted = _notes.where((e) => e.deleted).toList();
    _notesArchived = _notes.where((e) => e.archived && !e.deleted).toList();
    _notesPinned = _notes
        .where((e) => e.pinned && !e.archived && !e.deleted)
        .toList();

    _notesDefault = [
      ..._notesPinned,
      ..._notes.where((e) => !e.pinned && !e.archived && !e.deleted),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final note = Note.create(
      title: title,
      content: content,
      pinned: false,
      archived: false,
      deleted: false,
    );
    await HiveService.addNote(note);
    _notes.insert(0, note);
    notifyListeners();
  }

  Future<void> updateNote(
    String id,
    String title,
    String content,
    bool isPinned,
    bool isArchive,
  ) async {
    final note = _notes.firstWhere((n) => n.id == id);
    note.updateNote(
      title: title,
      content: content,
      pinned: isPinned,
      archived: isArchive,
    );
    await HiveService.updateNote(note);

    // Refresh the list to maintain sort order
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  Future<void> archiveNote(String id, bool archive) async {
    final note = _notes.firstWhere((n) => n.id == id);
    note.updateNote(archived: archive);
    await HiveService.updateNote(note);

    _notesDefault.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  Future<void> deleteNote(String id, bool delete) async {
    final note = _notes.firstWhere((n) => n.id == id);
    note.updateNote(deleted: delete);
    await HiveService.updateNote(note);
    
    _notesDefault.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  Future<void> deleteNotePermanent(String id) async {
    await HiveService.deleteNote(id);
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  List<Note> searchNotes(String query) {
    return HiveService.searchNotes(query);
  }
}
