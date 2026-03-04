// lib/utils/helpers.dart
// Équivalent de cn.ts - Utilitaires pour les styles

import 'package:flutter/material.dart';

/// Utilitaire pour combiner des conditions de style
/// Équivalent de clsx/tailwind-merge
class StyleHelper {
  /// Combine plusieurs styles conditionnels
  static List<T> combine<T>(List<T?> styles) {
    return styles.whereType<T>().toList();
  }

  /// Pour les couleurs conditionnelles
  static Color? colorFromCondition(bool condition, Color ifTrue, Color ifFalse) {
    return condition ? ifTrue : ifFalse;
  }

  /// Pour les padding conditionnels
  static EdgeInsets? paddingFromCondition(
    bool condition,
    EdgeInsets ifTrue,
    EdgeInsets ifFalse,
  ) {
    return condition ? ifTrue : ifFalse;
  }
}

/// Extension pour faciliter les conditions de style
extension StylingExtension on BuildContext {
  /// Retourne une couleur basée sur une condition
  Color color(bool condition, Color ifTrue, Color ifFalse) {
    return condition ? ifTrue : ifFalse;
  }

  /// Retourne un style de texte basé sur une condition
  TextStyle textStyle(bool condition, TextStyle ifTrue, TextStyle ifFalse) {
    return condition ? ifTrue : ifFalse;
  }
}

/// Pour combiner plusieurs styles de manière conditionnelle
class StyleMerge {
  static List<dynamic> merge(List<dynamic> styles) {
    return styles.where((s) => s != null && s != false).toList();
  }
}