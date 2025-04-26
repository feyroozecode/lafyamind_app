// lib/src/features/feed/presentation/providers/feed_provider.dart
import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../domain/feed_item.dart';

// Le provider qui expose un feed de 10 items mélangés
final feedProvider = Provider<List<FeedItem>>((ref) {
  final List<FeedItem> allItems = [
    PostItem(
      id: 'post1',
      title: 'Conseil de pleine conscience du jour',
      author: 'Dr Anya Sharma',
      content:
          'Prenez 5 minutes aujourd\'hui pour vous concentrer sur votre respiration.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      imageUrl:
          'https://images.pexels.com/photos/386009/pexels-photo-386009.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
    ArticleItem(
      id: 'article1',
      title: 'Understanding Anxiety: Causes and Treatments',
      source: 'Mental Health Foundation',
      summary:
          'An overview of anxiety disorders, exploring common triggers and treatments.',
      url: 'https://example.com/understanding-anxiety',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      imageUrl:
          'https://images.pexels.com/photos/7176026/pexels-photo-7176026.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
    VideoItem(
      id: 'video1',
      title: 'Guided Meditation for Relaxation',
      channel: 'Calm Minds',
      videoUrl: 'https://example.com/meditation-video',
      thumbnailUrl:
          'https://images.pexels.com/photos/3771089/pexels-photo-3771089.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    PostItem(
      id: 'post2',
      title: 'Bienfaits de la tenue d\'un journal',
      author: 'Membre de la communauté',
      content:
          'Tenir un journal quotidiennement m\'a aidé à traiter mes pensées.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    // ➡️ Ajoutons d'autres exemples pour arriver à au moins 10 items
    ArticleItem(
      id: 'article2',
      title: 'Techniques de respiration contre le stress',
      source: 'Better You',
      summary: 'Comment utiliser la respiration pour calmer votre esprit.',
      url: 'https://example.com/breathing-techniques',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      imageUrl:
          'https://images.pexels.com/photos/4101550/pexels-photo-4101550.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
    PostItem(
      id: 'post3',
      title: 'Astuce bien-être : gratitude du matin',
      author: 'Coach Santé',
      content:
          'Chaque matin, pensez à 3 choses pour lesquelles vous êtes reconnaissant.',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    VideoItem(
      id: 'video2',
      title: 'Yoga pour débutants',
      channel: 'Zen Vibes',
      videoUrl: 'https://example.com/yoga-beginners',
      thumbnailUrl:
          'https://images.pexels.com/photos/317157/pexels-photo-317157.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ArticleItem(
      id: 'article3',
      title: 'Bien dormir pour une meilleure santé mentale',
      source: 'Sleep Foundation',
      summary: 'L\'impact du sommeil sur votre bien-être mental.',
      url: 'https://example.com/sleep-health',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      imageUrl:
          'https://images.pexels.com/photos/935743/pexels-photo-935743.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
    PostItem(
      id: 'post4',
      title: 'Mon expérience avec la thérapie cognitive',
      author: 'Utilisateur Anonyme',
      content: 'Partager mon parcours m\'a permis d\'aller mieux.',
      timestamp: DateTime.now().subtract(const Duration(days: 9)),
    ),
    VideoItem(
      id: 'video3',
      title: 'Relaxation sonore : bruit de pluie',
      channel: 'Nature Sound',
      videoUrl: 'https://example.com/rain-sounds',
      thumbnailUrl:
          'https://images.pexels.com/photos/110874/pexels-photo-110874.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Mélange aléatoirement les items
  allItems.shuffle(Random());

  // On retourne seulement les 10 premiers
  return allItems.take(10).toList();
});
