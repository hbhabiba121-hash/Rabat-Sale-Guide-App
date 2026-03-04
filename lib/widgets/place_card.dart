// lib/widgets/place_card.dart

import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onClick;
  final VoidCallback? onFavorite;
  final bool compact;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onClick,
    this.onFavorite,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return compact ? _buildCompactCard(context) : _buildFullCard(context);
  }

  Widget _buildFullCard(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
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
            // Image avec catégorie et bouton favori
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    place.image,
                    height: 120, // ENCORE RÉDUIT de 140 à 120
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 30, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                
                // Badge catégorie
                Positioned(
                  top: 6, // RÉDUIT de 8 à 6
                  left: 6, // RÉDUIT de 8 à 6
                  child: _buildCategoryBadge(),
                ),

                // Bouton favori
                if (onFavorite != null)
                  Positioned(
                    top: 6, // RÉDUIT de 8 à 6
                    right: 6, // RÉDUIT de 8 à 6
                    child: _buildFavoriteButton(),
                  ),
              ],
            ),

            // Contenu
            Padding(
              padding: const EdgeInsets.all(10), // RÉDUIT de 12 à 10
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nom
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 14, // RÉDUIT de 16 à 14
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Nom arabe (optionnel - réduire l'espace)
                  if (place.nameAr != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 1), // RÉDUIT de 2 à 1
                      child: Text(
                        place.nameAr!,
                        style: const TextStyle(
                          fontSize: 11, // RÉDUIT de 12 à 11
                          color: Colors.grey,
                        ),
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const SizedBox(height: 4), // RÉDUIT de 6 à 4

                  // Adresse
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 10, // RÉDUIT de 12 à 10
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          place.address.split(',').first,
                          style: const TextStyle(
                            fontSize: 10, // RÉDUIT de 12 à 10
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4), // RÉDUIT de 6 à 4

                  // Note et prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Partie gauche (note)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12, // RÉDUIT de 14 à 12
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              place.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12, // RÉDUIT de 14 à 12
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                '(${place.reviews})',
                                style: const TextStyle(
                                  fontSize: 9, // RÉDUIT de 10 à 9
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Partie droite (prix)
                      if (place.priceRange != null)
                        Text(
                          place.priceRange!,
                          style: const TextStyle(
                            fontSize: 10, // RÉDUIT de 12 à 10
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF059669),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  Widget _buildCompactCard(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(8), // RÉDUIT de 10 à 8
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
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                place.image,
                width: 55, // RÉDUIT de 60 à 55
                height: 55, // RÉDUIT de 60 à 55
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 55,
                  height: 55,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 8), // RÉDUIT de 10 à 8

            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 13, // RÉDUIT de 14 à 13
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 9, // RÉDUIT de 10 à 9
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: Text(
                          place.address.split(',').first,
                          style: const TextStyle(
                            fontSize: 10, // RÉDUIT de 11 à 10
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 10, // RÉDUIT de 11 à 10
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 1),
                      Text(
                        place.rating.toString(),
                        style: const TextStyle(
                          fontSize: 10, // RÉDUIT de 11 à 10
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
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

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6, // RÉDUIT de 8 à 6
        vertical: 2, // RÉDUIT de 3 à 2
      ),
      decoration: BoxDecoration(
        color: _getCategoryColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getCategoryLabel(),
        style: TextStyle(
          fontSize: 9, // RÉDUIT de 10 à 9
          fontWeight: FontWeight.w500,
          color: _getCategoryTextColor(),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () {
        if (onFavorite != null) {
          onFavorite!();
        }
      },
      child: Container(
        width: 24, // RÉDUIT de 28 à 24
        height: 24, // RÉDUIT de 28 à 24
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          place.isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 14, // RÉDUIT de 16 à 14
          color: place.isFavorite ? Colors.red : Colors.grey,
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (place.category) {
      case PlaceCategory.monument:
        return const Color(0xFFFFF3E0);
      case PlaceCategory.restaurant:
        return const Color(0xFFFFE4E6);
      case PlaceCategory.cafe:
        return const Color(0xFFFFEDD5);
      case PlaceCategory.museum:
        return const Color(0xFFF3E8FF);
      case PlaceCategory.park:
        return const Color(0xFFDCFCE7);
      case PlaceCategory.event:
        return const Color(0xFFDBEAFE);
    }
  }

  Color _getCategoryTextColor() {
    switch (place.category) {
      case PlaceCategory.monument:
        return const Color(0xFFB45309);
      case PlaceCategory.restaurant:
        return const Color(0xFFB91C1C);
      case PlaceCategory.cafe:
        return const Color(0xFFC2410C);
      case PlaceCategory.museum:
        return const Color(0xFF6D28D9);
      case PlaceCategory.park:
        return const Color(0xFF047857);
      case PlaceCategory.event:
        return const Color(0xFF1D4ED8);
    }
  }

  String _getCategoryLabel() {
    switch (place.category) {
      case PlaceCategory.monument:
        return 'Monument';
      case PlaceCategory.restaurant:
        return 'Restaurant';
      case PlaceCategory.cafe:
        return 'Café';
      case PlaceCategory.museum:
        return 'Musée';
      case PlaceCategory.park:
        return 'Parc';
      case PlaceCategory.event:
        return 'Événement';
    }
  }
}