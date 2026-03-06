import "package:equatable/equatable.dart";

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final String plainContent;
  final int color;
  final String? categoryId;
  final bool isPinned;
  final bool isFavorite;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reminderTime;
  final List<String> tags;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.plainContent,
    this.color = 0,
    this.categoryId,
    this.isPinned = false,
    this.isFavorite = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
    this.reminderTime,
    this.tags = const [],
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? plainContent,
    int? color,
    String? categoryId,
    bool? isPinned,
    bool? isFavorite,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? reminderTime,
    List<String>? tags,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      plainContent: plainContent ?? this.plainContent,
      color: color ?? this.color,
      categoryId: categoryId ?? this.categoryId,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderTime: reminderTime ?? this.reminderTime,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "plainContent": plainContent,
      "color": color,
      "categoryId": categoryId,
      "isPinned": isPinned ? 1 : 0,
      "isFavorite": isFavorite ? 1 : 0,
      "isArchived": isArchived ? 1 : 0,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "reminderTime": reminderTime?.toIso8601String(),
      "tags": tags.join(","),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      title: map["title"],
      content: map["content"],
      plainContent: map["plainContent"],
      color: map["color"] ?? 0,
      categoryId: map["categoryId"],
      isPinned: map["isPinned"] == 1,
      isFavorite: map["isFavorite"] == 1,
      isArchived: map["isArchived"] == 1,
      createdAt: DateTime.parse(map["createdAt"]),
      updatedAt: DateTime.parse(map["updatedAt"]),
      reminderTime: map["reminderTime"] != null ? DateTime.parse(map["reminderTime"]) : null,
      tags: map["tags"] != null && map["tags"].toString().isNotEmpty
          ? map["tags"].toString().split(",")
          : [],
    );
  }

  @override
  List<Object?> get props => [id, title, content, plainContent, color, categoryId, isPinned, isFavorite, isArchived, createdAt, updatedAt, reminderTime, tags];
}
