// lib/models/itinerary_step.dart

import 'place.dart';

class ItineraryStep {
  final String id;
  final String title;
  final String description;
  final Place? place;
  final String? image;
  final int order;
  final Duration? estimatedTime;
  final String? transportMode;

  const ItineraryStep({
    required this.id,
    required this.title,
    required this.description,
    this.place,
    this.image,
    required this.order,
    this.estimatedTime,
    this.transportMode,
  });
}