class Work {
  final int id;
  final String title;
  final String description;
  final String dateAssigned;
  final String dueDate;
  final String status;

  Work({
    required this.id,
    required this.title,
    required this.description,
    required this.dateAssigned,
    required this.dueDate,
    required this.status,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateAssigned: json['date_assigned'],
      dueDate: json['due_date'],
      status: json['status'],
    );
  }
}
