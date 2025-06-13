import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/learning_article.dart';

// Provider pour les articles sur la santé mentale
final mentalHealthArticlesProvider = Provider<List<LearningArticle>>((ref) {
  return [
    LearningArticle(
      id: 'mental_health_basics',
      title: 'Les Bases de la Santé Mentale',
      category: 'Santé Mentale',
      author: 'Équipe LaFyaMind',
      summary: 'Une introduction aux concepts fondamentaux de la santé mentale, son importance, et comment la préserver au quotidien.',
      fullContent: 'assets/md/mental_health/basics.md',
      imageUrl: 'https://images.pexels.com/photos/3758105/pexels-photo-3758105.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      estimatedReadTime: const Duration(minutes: 7),
    ),
    LearningArticle(
      id: 'mental_health_anxiety',
      title: 'L\'Anxiété : Comprendre et Gérer',
      category: 'Anxiété',
      author: 'Équipe LaFyaMind',
      summary: 'Comprendre les différents types d\'anxiété, leurs symptômes, et découvrir des stratégies efficaces pour les gérer au quotidien.',
      fullContent: 'assets/md/mental_health/anxiety.md',
      imageUrl: 'https://images.pexels.com/photos/3047316/pexels-photo-3047316.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      estimatedReadTime: const Duration(minutes: 8),
    ),
    LearningArticle(
      id: 'mental_health_depression',
      title: 'La Dépression : Comprendre et Surmonter',
      category: 'Dépression',
      author: 'Équipe LaFyaMind',
      summary: 'Un guide complet sur la dépression, ses symptômes, ses causes, et les stratégies efficaces pour la combattre et retrouver le bien-être.',
      fullContent: 'assets/md/mental_health/depression.md',
      imageUrl: 'https://images.pexels.com/photos/4098228/pexels-photo-4098228.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      estimatedReadTime: const Duration(minutes: 9),
    ),
    LearningArticle(
      id: 'mental_health_stress',
      title: 'La Gestion du Stress : Comprendre et Maîtriser',
      category: 'Gestion du Stress',
      author: 'Équipe LaFyaMind',
      summary: 'Découvrez les mécanismes du stress, ses effets sur la santé, et apprenez des techniques efficaces pour le gérer et préserver votre équilibre.',
      fullContent: 'assets/md/mental_health/stress_management.md',
      imageUrl: 'https://images.pexels.com/photos/897817/pexels-photo-897817.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      estimatedReadTime: const Duration(minutes: 8),
    ),
    LearningArticle(
      id: 'mental_health_wellbeing',
      title: 'Le Bien-être Mental : Cultiver une Santé Mentale Positive',
      category: 'Bien-être',
      author: 'Équipe LaFyaMind',
      summary: 'Explorez les fondements du bien-être mental et découvrez des pratiques concrètes pour nourrir et renforcer votre santé mentale au quotidien.',
      fullContent: 'assets/md/mental_health/well_being.md',
      imageUrl: 'https://images.pexels.com/photos/1028741/pexels-photo-1028741.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      estimatedReadTime: const Duration(minutes: 7),
    ),
  ];
});

// Fonction pour charger le contenu du fichier Markdown
Future<String> loadMarkdownContent(String assetPath) async {
  try {
    return await rootBundle.loadString(assetPath);
  } catch (e) {
    return "**Erreur de chargement du contenu**\n\nLe contenu demandé n'a pas pu être chargé. Veuillez réessayer plus tard.";
  }
}