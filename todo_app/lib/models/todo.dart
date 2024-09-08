class Todo {
  String id;
  String title;
  bool completed;
  DateTime createdAt;
  String colorLabel; // Field to store the color label
  String category;
  List<String> labels; // Define labels as a list of strings

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
    required this.createdAt,
    this.colorLabel = 'grey', // Default color
    this.category = '',
    this.labels = const [], // Initialize labels as an empty list by default
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      completed: json['completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      colorLabel: json['colorLabel'] ?? 'grey', // Handle color label from JSON
      category: json['category'] ?? '',
      labels: List<String>.from(json['labels'] ?? []), // Parse labels from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'created_at': createdAt.toIso8601String(),
      'colorLabel': colorLabel, // Include color label in JSON
      'category': category,
      'labels': labels, // Include labels in JSON
    };
  }
}
