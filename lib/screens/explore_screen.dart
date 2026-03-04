// lib/screens/explore_screen.dart

import 'package:flutter/material.dart';
import '../models/place.dart';
import '../widgets/place_card.dart';

class ExploreScreen extends StatefulWidget {
  final List<Place> places;
  final Function(Place) onPlaceClick;
  final List<String> favorites;
  final Function(String) onToggleFavorite;
  final String? initialCategory;

  const ExploreScreen({
    super.key,
    required this.places,
    required this.onPlaceClick,
    required this.favorites,
    required this.onToggleFavorite,
    this.initialCategory,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late String _searchQuery;
  late String? _selectedCategory;

  final List<CategoryItem> _categories = [
    CategoryItem(id: 'monument', label: 'Monuments'),
    CategoryItem(id: 'restaurant', label: 'Restaurants'),
    CategoryItem(id: 'cafe', label: 'Cafés'),
    CategoryItem(id: 'museum', label: 'Musées'),
    CategoryItem(id: 'park', label: 'Parcs'),
  ];

  @override
  void initState() {
    super.initState();
    _searchQuery = '';
    _selectedCategory = widget.initialCategory;
  }

  List<Place> get _filteredPlaces {
    return widget.places.where((place) {
      // Filtre par recherche
      final matchesSearch = _searchQuery.isEmpty ||
          place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.tags.any((tag) =>
              tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      // Filtre par catégorie
      final matchesCategory = _selectedCategory == null ||
          place.category.toString().split('.').last == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header sticky
            _buildHeader(),
            
            // Résultats
            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explorer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          
          // Barre de recherche
          _buildSearchBar(),
          
          const SizedBox(height: 16),
          
          // Filtres catégories
          _buildCategoryFilters(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: Colors.grey,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Bouton "Tout"
          _buildFilterChip(
            label: 'Tout',
            isSelected: _selectedCategory == null,
            onTap: () {
              setState(() {
                _selectedCategory = null;
              });
            },
          ),
          const SizedBox(width: 8),
          
          // Boutons par catégorie
          ..._categories.map((category) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildFilterChip(
              label: category.label,
              isSelected: _selectedCategory == category.id,
              onTap: () {
                setState(() {
                  _selectedCategory = category.id;
                });
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF059669) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final filteredPlaces = _filteredPlaces;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Compteur de résultats
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _getResultsText(filteredPlaces.length),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),

        // Liste des résultats
        Expanded(
          child: filteredPlaces.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPlaces.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    return PlaceCard(
                      place: place.copyWith(
                        isFavorite: widget.favorites.contains(place.id),
                      ),
                      onClick: () => widget.onPlaceClick(place),
                      onFavorite: () => widget.onToggleFavorite(place.id),
                    );
                  },
                )
              : _buildEmptyState(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 28,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun résultat trouvé',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Essayez de modifier vos critères de recherche',
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

  String _getResultsText(int count) {
    if (count == 0) return 'Aucun résultat trouvé';
    if (count == 1) return '1 résultat trouvé';
    return '$count résultats trouvés';
  }
}

// Classe helper pour les catégories
class CategoryItem {
  final String id;
  final String label;

  CategoryItem({
    required this.id,
    required this.label,
  });
}