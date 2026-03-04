// lib/screens/place_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback onNavigate;

  const PlaceDetailScreen({
    super.key,
    required this.place,
    required this.onBack,
    required this.onFavorite,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Contenu scrollable
          CustomScrollView(
            slivers: [
              // Hero Image avec AppBar flottante
              SliverAppBar(
                expandedHeight: 300,
                pinned: false,
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      Image.network(
                        place.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                              Colors.black87,
                            ],
                          ),
                        ),
                      ),
                      // Titre overlay
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryBadge(),
                            const SizedBox(height: 8),
                            Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            if (place.nameAr != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  place.nameAr!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Contenu
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Note et prix
                    _buildRatingAndPrice(),

                    const SizedBox(height: 20),

                    // Description
                    _buildSection(
                      title: 'À propos',
                      child: Text(
                        place.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF4B5563),
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Informations
                    ..._buildInfoCards(),

                    const SizedBox(height: 20),

                    // Tags
                    _buildTagsSection(),

                    const SizedBox(height: 20),

                    // Bouton navigation
                    _buildNavigateButton(),

                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),

          // Boutons flottants
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: _buildBackButton(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: _buildFavoriteButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _getCategoryColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getCategoryLabel(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getCategoryTextColor(),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9), // CORRIGÉ
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // CORRIGÉ
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, size: 20),
        onPressed: onBack,
        padding: EdgeInsets.zero,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9), // CORRIGÉ
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // CORRIGÉ
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          place.isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 20,
          color: place.isFavorite ? Colors.red : Colors.grey[600],
        ),
        onPressed: onFavorite,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildRatingAndPrice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star,
                size: 24,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              Text(
                place.rating.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${place.reviews} avis)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (place.priceRange != null)
            Text(
              place.priceRange!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF059669),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildInfoCards() {
    List<Widget> cards = [];

    if (place.address.isNotEmpty) {
      cards.add(_buildInfoCard(
        icon: Icons.location_on,
        title: 'Adresse',
        content: place.address,
      ));
    }

    if (place.openingHours != null) {
      cards.add(_buildInfoCard(
        icon: Icons.access_time,
        title: 'Horaires',
        content: place.openingHours!,
      ));
    }

    if (place.phone != null) {
      cards.add(_buildInfoCard(
        icon: Icons.phone,
        title: 'Téléphone',
        content: place.phone!,
        isPhone: true,
      ));
    }

    return cards;
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF059669),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isPhone ? const Color(0xFF059669) : const Color(0xFF1F2937),
                      fontWeight: isPhone ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.tag,
              size: 18,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: place.tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF047857),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNavigateButton() {
    return ElevatedButton(
      onPressed: onNavigate,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        shadowColor: const Color(0xFF059669).withValues(alpha: 0.3), // CORRIGÉ
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.navigation, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Voir sur la carte',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
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