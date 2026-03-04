// lib/models/event.dart

class Event {
  final String id;
  final String title;
  final String date;
  final String location;
  final String description;
  final String image;
  final String category;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.image,
    required this.category,
  });
}