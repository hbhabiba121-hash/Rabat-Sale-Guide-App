// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import '../models/place.dart';
import '../widgets/place_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Place> places;
  final List<String> favorites;
  final Function(Place) onPlaceClick;
  final Function(String) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.places,
    required this.favorites,
    required this.onPlaceClick,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final favoritePlaces = places.where((p) => favorites.contains(p.id)).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(context, favoritePlaces.length),
            
            // Content
            Expanded(
              child: _buildContent(context, favoritePlaces),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          // Icone de cœur
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6), // rose-100
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.favorite,
              size: 24,
              color: Color(0xFFF43F5E), // rose-500
            ),
          ),
          const SizedBox(width: 12),
          
          // Titre et compteur
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mes Favoris',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCountText(count),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Place> favoritePlaces) {
    if (favoritePlaces.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: favoritePlaces.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final place = favoritePlaces[index];
          return PlaceCard(
            place: place.copyWith(isFavorite: true),
            onClick: () => onPlaceClick(place),
            onFavorite: () => onToggleFavorite(place.id),
          );
        },
      );
    }

    // État vide
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 32,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun favori',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explorez les lieux et ajoutez-les à vos favoris pour les retrouver facilement',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCountText(int count) {
    if (count == 0) return 'Aucun lieu sauvegardé';
    if (count == 1) return '1 lieu sauvegardé';
    return '$count lieux sauvegardés';
  }
}