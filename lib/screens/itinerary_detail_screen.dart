// lib/screens/itinerary_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/itinerary.dart';
import '../models/place.dart';
import '../models/itinerary_step.dart';
import '../widgets/place_card.dart';

class ItineraryDetailScreen extends StatelessWidget {
  final Itinerary itinerary;
  final Function(Place) onPlaceClick;
  final List<String> favorites;
  final Function(String) onToggleFavorite;

  const ItineraryDetailScreen({
    super.key,
    required this.itinerary,
    required this.onPlaceClick,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar avec image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    itinerary.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                      Container(color: Colors.grey[300]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                itinerary.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Contenu
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Métriques
                _buildMetrics(),
                const SizedBox(height: 20),

                // Description
                _buildSection(
                  title: 'Description',
                  child: Text(
                    itinerary.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),

                // Informations pratiques
                if (itinerary.difficulty != null || itinerary.bestSeason != null)
                  _buildPracticalInfo(),
                const SizedBox(height: 20),

                // Conseils
                if (itinerary.tips != null && itinerary.tips!.isNotEmpty)
                  _buildTips(),
                const SizedBox(height: 20),

                // Étapes
                _buildSection(
                  title: 'Étapes de l\'itinéraire',
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      ...itinerary.steps.map((step) => _buildStepCard(step)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Lieux inclus
                _buildSection(
                  title: 'Lieux à découvrir',
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      ...itinerary.places.map((place) => PlaceCard(
                        place: place.copyWith(isFavorite: favorites.contains(place.id)),
                        onClick: () => onPlaceClick(place),
                        onFavorite: () => onToggleFavorite(place.id),
                        compact: true,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Bouton démarrer
                _buildStartButton(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            icon: Icons.access_time,
            value: itinerary.duration,
            label: 'Durée',
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildMetricItem(
            icon: Icons.flag,
            value: itinerary.stepsCount.toString(),
            label: 'Étapes',
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildMetricItem(
            icon: Icons.location_on,
            value: itinerary.placesCount.toString(),
            label: 'Lieux',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF059669), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPracticalInfo() {
    return _buildSection(
      title: 'Informations pratiques',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            if (itinerary.difficulty != null)
              _buildInfoRow(
                icon: Icons.assessment,
                label: 'Difficulté',
                value: itinerary.difficulty!,
              ),
            if (itinerary.bestSeason != null)
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Meilleure saison',
                value: itinerary.bestSeason!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF059669)),
          const SizedBox(width: 12),
          Text(
            '$label :',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return _buildSection(
      title: 'Conseils',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFE082)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: itinerary.tips!.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Color(0xFFFFA000),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildStepCard(ItineraryStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Numéro d'étape
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                '${step.order}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF059669),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  if (step.estimatedTime != null || step.transportMode != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Wrap(
                        spacing: 12,
                        children: [
                          if (step.estimatedTime != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Color(0xFF059669),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  _formatDuration(step.estimatedTime!),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          if (step.transportMode != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.directions,
                                  size: 12,
                                  color: Color(0xFF059669),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  step.transportMode!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
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
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h${duration.inMinutes.remainder(60)}min';
    }
    return '${duration.inMinutes}min';
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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: () {
        // Démarrer l'itinéraire
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Démarrer cet itinéraire',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}