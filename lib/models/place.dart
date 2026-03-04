// lib/models/place.dart

enum PlaceCategory {
  monument,
  restaurant,
  cafe,
  museum,
  park,
  event;

  static PlaceCategory fromString(String value) {
    switch (value) {
      case 'monument':
        return PlaceCategory.monument;
      case 'restaurant':
        return PlaceCategory.restaurant;
      case 'cafe':
        return PlaceCategory.cafe;
      case 'museum':
        return PlaceCategory.museum;
      case 'park':
        return PlaceCategory.park;
      case 'event':
        return PlaceCategory.event;
      default:
        return PlaceCategory.monument;
    }
  }

  String get displayName {
    switch (this) {
      case PlaceCategory.monument:
        return 'Monuments';
      case PlaceCategory.restaurant:
        return 'Restaurants';
      case PlaceCategory.cafe:
        return 'Cafés';
      case PlaceCategory.museum:
        return 'Musées';
      case PlaceCategory.park:
        return 'Parcs';
      case PlaceCategory.event:
        return 'Événements';
    }
  }
}

class Place {
  final String id;
  final String name;
  final String? nameAr;
  final PlaceCategory category;
  final String description;
  final String image;
  final double rating;
  final int reviews;
  final String address;
  final double lat;
  final double lng;
  final String? openingHours;
  final String? phone;
  final String? priceRange;
  final List<String> tags;
  bool isFavorite;

  Place({
    required this.id,
    required this.name,
    this.nameAr,
    required this.category,
    required this.description,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.address,
    required this.lat,
    required this.lng,
    this.openingHours,
    this.phone,
    this.priceRange,
    required this.tags,
    this.isFavorite = false,
  });

  Place copyWith({
    String? id,
    String? name,
    String? nameAr,
    PlaceCategory? category,
    String? description,
    String? image,
    double? rating,
    int? reviews,
    String? address,
    double? lat,
    double? lng,
    String? openingHours,
    String? phone,
    String? priceRange,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      category: category ?? this.category,
      description: description ?? this.description,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      openingHours: openingHours ?? this.openingHours,
      phone: phone ?? this.phone,
      priceRange: priceRange ?? this.priceRange,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}