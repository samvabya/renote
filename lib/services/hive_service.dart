import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class HiveService {
  static const String _notesBox = 'notes_box';
  static Box<Note>? _notesBoxInstance;

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Register adapters
    Hive.registerAdapter(NoteAdapter());
    
    // Open boxes
    _notesBoxInstance = await Hive.openBox<Note>(_notesBox);
  }

  // Add a new note
  static Future<void> addNote(Note note) async {
    await _notesBoxInstance?.put(note.id, note);
  }

  // Get all notes
  static List<Note> getAllNotes() {
    return _notesBoxInstance?.values.toList() ?? [];
  }

  // Get a specific note
  static Note? getNote(String id) {
    return _notesBoxInstance?.get(id);
  }

  // Update a note
  static Future<void> updateNote(Note note) async {
    await _notesBoxInstance?.put(note.id, note);
  }

  // Delete a note
  static Future<void> deleteNote(String id) async {
    await _notesBoxInstance?.delete(id);
  }

  // Delete all notes
  static Future<void> deleteAllNotes() async {
    await _notesBoxInstance?.clear();
  }

  // Search notes
  static List<Note> searchNotes(String query) {
    final allNotes = getAllNotes();
    if (query.isEmpty) return allNotes;
    
    return allNotes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
             note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Close Hive
  static Future<void> close() async {
    await _notesBoxInstance?.close();
  }
}