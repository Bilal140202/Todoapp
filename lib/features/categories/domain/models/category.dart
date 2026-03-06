import "package:equatable/equatable.dart";

class Category extends Equatable {
  final String id;
  final String name;
  final int color;
  final int icon;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    this.color = 0,
    this.icon = 0,
    required this.createdAt,
  });

  Category copyWith({
    String? id,
    String? name,
    int? color,
    int? icon,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "color": color,
      "icon": icon,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map["id"],
      name: map["name"],
      color: map["color"] ?? 0,
      icon: map["icon"] ?? 0,
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }

  @override
  List<Object?> get props => [id, name, color, icon, createdAt];
}
