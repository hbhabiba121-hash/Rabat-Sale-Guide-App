// lib/screens/home_screen.dart (complet avec toutes les méthodes)

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../models/place.dart';
import '../models/event.dart';
import '../models/itinerary.dart';
import '../widgets/place_card.dart';
import 'itinerary_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Place> places;
  final List<Event> events;
  final List<Itinerary> itineraries;
  final Function(Place) onPlaceClick;
  final Function(PlaceCategory) onCategoryClick;
  final VoidCallback onExploreClick;
  final List<String> favorites;
  final Function(String) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.places,
    required this.events,
    required this.itineraries,
    required this.onPlaceClick,
    required this.onCategoryClick,
    required this.onExploreClick,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final featuredPlaces = places.where((p) => p.rating >= 4.6).take(4).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildCategories(context),
              _buildFeaturedPlaces(context, featuredPlaces),
              _buildItineraries(context),
              _buildEvents(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF059669), Color(0xFF0F766E)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Rabat-Salé',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Guide Touristique Interactif',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[100],
            ),
          ),
          const SizedBox(height: 24),
          Material(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onExploreClick,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Feather.search,
                      size: 20,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Rechercher un lieu, restaurant, café...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      _CategoryItem(
        category: PlaceCategory.monument,
        icon: Feather.home,
        color: const Color(0xFFFEF3C7),
        iconColor: const Color(0xFFD97706),
      ),
      _CategoryItem(
        category: PlaceCategory.restaurant,
        icon: Feather.coffee,
        color: const Color(0xFFFFE4E6),
        iconColor: const Color(0xFFE11D48),
      ),
      _CategoryItem(
        category: PlaceCategory.cafe,
        icon: Feather.coffee,
        color: const Color(0xFFFFEDD5),
        iconColor: const Color(0xFFEA580C),
      ),
      _CategoryItem(
        category: PlaceCategory.museum,
        icon: Feather.home,
        color: const Color(0xFFF3E8FF),
        iconColor: const Color(0xFF9333EA),
      ),
      _CategoryItem(
        category: PlaceCategory.park,
        icon: Feather.github,
        color: const Color(0xFFDCFCE7),
        iconColor: const Color(0xFF16A34A),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catégories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 12),
              itemBuilder: (BuildContext context, int index) {
                final item = categories[index];
                return _buildCategoryButton(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, _CategoryItem item) {
    return GestureDetector(
      onTap: () => onCategoryClick(item.category),
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: item.iconColor,
            ),
            const SizedBox(height: 8),
            Text(
              item.category.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: item.iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedPlaces(BuildContext context, List<Place> featuredPlaces) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'À découvrir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              TextButton(
                onPressed: onExploreClick,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF059669),
                ),
                child: const Row(
                  children: [
                    Text('Voir tout'),
                    SizedBox(width: 4),
                    Icon(Feather.chevron_right, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: featuredPlaces.length,
            itemBuilder: (BuildContext context, int index) {
              final place = featuredPlaces[index];
              return PlaceCard(
                place: place.copyWith(isFavorite: favorites.contains(place.id)),
                onClick: () => onPlaceClick(place),
                onFavorite: () => onToggleFavorite(place.id),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItineraries(BuildContext context) {
    if (itineraries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Itinéraires suggérés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: itineraries.length,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 16),
              itemBuilder: (BuildContext context, int index) {
                final itinerary = itineraries[index];
                return _buildItineraryCard(context, itinerary);
              },
            ),
          ),
        ],
      ),
    );
  }

 // lib/screens/home_screen.dart - Modifier seulement la méthode _buildItineraryCard

Widget _buildItineraryCard(BuildContext context, Itinerary itinerary) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItineraryDetailScreen(
            itinerary: itinerary,
            onPlaceClick: onPlaceClick,
            favorites: favorites,
            onToggleFavorite: onToggleFavorite,
          ),
        ),
      );
    },
    child: Container(
      width: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              itinerary.image,
              height: 95, // RÉDUIT DE 100 À 95px
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                height: 95,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7), // RÉDUIT DE 8 À 7px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  itinerary.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1), // RÉDUIT DE 2 À 1px
                Text(
                  itinerary.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1), // RÉDUIT DE 2 À 1px
                Row(
                  children: [
                    Text(
                      itinerary.duration,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(width: 1), // RÉDUIT DE 2 À 1px
                    const Text(
                      '•',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 1), // RÉDUIT DE 2 À 1px
                    Text(
                      '${itinerary.placesCount} lieux',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    if (itinerary.rating != null) ...[
                      const SizedBox(width: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 8, color: Colors.amber),
                          const SizedBox(width: 1),
                          Text(
                            itinerary.rating!.toString(),
                            style: const TextStyle(
                              fontSize: 8, // RÉDUIT DE 9 À 8px
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildEvents(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Événements à venir',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
            itemBuilder: (BuildContext context, int index) {
              final event = events[index];
              return _buildEventCard(context, event);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network(
              event.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                width: 70,
                height: 70,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 25, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    event.date,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    event.location,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final PlaceCategory category;
  final IconData icon;
  final Color color;
  final Color iconColor;

  _CategoryItem({
    required this.category,
    required this.icon,
    required this.color,
    required this.iconColor,
  });
}