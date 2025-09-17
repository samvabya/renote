import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  bool pinned;

  @HiveField(6)
  bool archived;

  @HiveField(7)
  bool deleted;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.pinned,
    required this.archived,
    required this.deleted,
  });

  Note.create({
    required this.title,
    required this.content,
    required this.pinned,
    required this.archived,
    required this.deleted,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString(),
       createdAt = DateTime.now(),
       updatedAt = DateTime.now();

  // Update note
  void updateNote({
    String? title,
    String? content,
    bool pinned = false,
    bool archived = false,
    bool deleted = false,
  }) {
    if (title != null) this.title = title;
    if (content != null) this.content = content;
    this.pinned = pinned;
    this.archived = archived;
    this.deleted = deleted;
    updatedAt = DateTime.now();
  }
}
