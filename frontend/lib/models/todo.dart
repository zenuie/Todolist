class Todo {
  final String id;
  final String? userId;
  final String? title;
  final String? description;
  final bool? complete;
  final int? sort;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Todo({
    required this.id,
    this.userId,
    this.title,
    this.description,
    this.complete,
    this.sort,
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      complete: json['complete'] as bool?,
      sort: json['sort'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'complete': complete,
      'sort': sort,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
