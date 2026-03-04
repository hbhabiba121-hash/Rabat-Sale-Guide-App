// lib/models/itinerary.dart

import 'place.dart';
import 'itinerary_step.dart';

class Itinerary {
  final String id;
  final String name;
  final String duration;
  final String description;
  final List<Place> places;
  final String image;
  final List<ItineraryStep> steps;
  final double? rating;
  final int? reviews;
  final String? difficulty;
  final String? bestSeason;
  final List<String>? tips;

  Itinerary({
    required this.id,
    required this.name,
    required this.duration,
    required this.description,
    required this.places,
    required this.image,
    required this.steps,
    this.rating,
    this.reviews,
    this.difficulty,
    this.bestSeason,
    this.tips,
  });

  int get placesCount => places.length;
  int get stepsCount => steps.length;
}