// lib/app.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/place_detail_screen.dart';
import 'screens/itinerary_detail_screen.dart';
import 'widgets/events_view.dart';
import 'widgets/bottom_nav_bar.dart';
import 'data/places_data.dart';
import 'models/place.dart';
import 'models/itinerary.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // Implémentez le chargement
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
    _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    // Implémentez la sauvegarde
  }

  void _showPlaceDetail(BuildContext context, Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(
          place: place.copyWith(isFavorite: _favorites.contains(place.id)),
          onBack: () => Navigator.pop(context),
          onFavorite: () => _toggleFavorite(place.id),
          onNavigate: () {
            Navigator.pop(context);
            context.go('/map', extra: place);
          },
        ),
      ),
    );
  }

  void _showItineraryDetail(BuildContext context, Itinerary itinerary) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItineraryDetailScreen(
          itinerary: itinerary,
          onPlaceClick: (place) => _showPlaceDetail(context, place),
          favorites: _favorites,
          onToggleFavorite: _toggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rabat-Salé Guide',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: _router,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF059669),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF059669),
        primary: const Color(0xFF059669),
        secondary: const Color(0xFF4F46E5),
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111827),
        ),
      ),
    );
  }

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => HomeScreen(
              places: places,
              events: events,
              itineraries: itineraries,
              onPlaceClick: (place) => _showPlaceDetail(context, place),
              onCategoryClick: (category) {
                context.go('/explore', extra: category.toString().split('.').last);
              },
              onExploreClick: () => context.go('/explore'),
              favorites: _favorites,
              onToggleFavorite: _toggleFavorite,
            ),
          ),
          GoRoute(
            path: '/explore',
            name: 'explore',
            builder: (context, state) {
              final initialCategory = state.extra as String?;
              return ExploreScreen(
                places: places,
                onPlaceClick: (place) => _showPlaceDetail(context, place),
                favorites: _favorites,
                onToggleFavorite: _toggleFavorite,
                initialCategory: initialCategory,
              );
            },
          ),
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            builder: (context, state) => FavoritesScreen(
              places: places,
              favorites: _favorites,
              onPlaceClick: (place) => _showPlaceDetail(context, place),
              onToggleFavorite: _toggleFavorite,
            ),
          ),
          GoRoute(
            path: '/events',
            name: 'events',
            builder: (context, state) => EventsView(
              events: events,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/place/:id',
        name: 'placeDetail',
        builder: (context, state) {
          final placeId = state.pathParameters['id'];
          final place = places.firstWhere((p) => p.id == placeId);
          return PlaceDetailScreen(
            place: place.copyWith(isFavorite: _favorites.contains(place.id)),
            onBack: () => Navigator.pop(context),
            onFavorite: () => _toggleFavorite(place.id),
            onNavigate: () {
              Navigator.pop(context);
              context.go('/map', extra: place);
            },
          );
        },
      ),
      GoRoute(
        path: '/itinerary/:id',
        name: 'itineraryDetail',
        builder: (context, state) {
          final itineraryId = state.pathParameters['id'];
          final itinerary = itineraries.firstWhere((i) => i.id == itineraryId);
          return ItineraryDetailScreen(
            itinerary: itinerary,
            onPlaceClick: (place) => _showPlaceDetail(context, place),
            favorites: _favorites,
            onToggleFavorite: _toggleFavorite,
          );
        },
      ),
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) {
          final place = state.extra as Place?;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Carte'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: place != null
                  ? Text('Carte centrée sur ${place.name}')
                  : const Text('Carte de la région'),
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Page non trouvée', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('La page que vous recherchez n\'existe pas', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => context.go('/'), child: const Text('Retour à l\'accueil')),
          ],
        ),
      ),
    ),
  );
}