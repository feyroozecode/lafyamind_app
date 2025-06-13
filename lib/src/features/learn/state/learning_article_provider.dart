// lib/src/features/learning/presentation/providers/learning_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/learning_article.dart';

final learningArticlesProvider = Provider<List<LearningArticle>>((ref) {
  // Sample Mental Health (MD) Articles
  return [
    LearningArticle(
      id: 'learn_anxiety_01',
      title: 'Stratégies d\'Adaptation Quotidiennes pour l\'Anxiété',
      category: 'Anxiété',
      author: 'Institut National de la Santé Mentale',
      summary:
          'Apprenez des techniques pratiques pour gérer les symptômes d\'anxiété dans votre vie quotidienne, de la respiration profonde à la pleine conscience.',
      fullContent: '''
    L'anxiété peut être accablante, mais plusieurs stratégies peuvent aider.
    \n\n**1. Respiration Profonde:** Inspirez lentement par le nez, retenez pendant quelques secondes, puis expirez lentement par la bouche. Répétez plusieurs fois.
    \n\n**2. Pleine Conscience (Mindfulness):** Concentrez-vous sur le moment présent. Observez vos pensées sans jugement. Utilisez vos sens pour vous ancrer.
    \n\n**3. Exercice Physique:** Une activité physique régulière libère des endorphines et réduit le stress.
    \n\n**4. Limiter la Caféine et l'Alcool:** Ces substances peuvent exacerber les symptômes d'anxiété chez certaines personnes.
    \n\n**5. Sommeil Suffisant:** Visez 7-9 heures de sommeil de qualité par nuit.
    \n\n*Consultez un professionnel de la santé pour un diagnostic et un plan de traitement personnalisé.*
          ''', // Add more detailed markdown/text content here
      imageUrl:
          'https://images.pexels.com/photos/3958416/pexels-photo-3958416.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      estimatedReadTime: const Duration(minutes: 5),
    ),
    LearningArticle(
      id: 'learn_depression_01',
      title: 'Comprendre la Dépression : Signes et Symptômes',
      category: 'Dépression',
      author: 'Organisation Mondiale de la Santé (OMS)',
      summary:
          'Un guide pour reconnaître les signes courants de la dépression chez soi ou chez les autres, et l\'importance de chercher de l\'aide.',
      fullContent: '''
    La dépression est plus qu'une simple tristesse passagère. C'est un trouble de l'humeur persistant qui affecte la façon dont vous vous sentez, pensez et agissez.
    \n\n**Signes Émotionnels Courants:**
    *   Tristesse persistante, vide, désespoir
    *   Perte d'intérêt ou de plaisir (anhédonie)
    *   Irritabilité, frustration
    *   Sentiments de culpabilité, d'inutilité
    \n\n**Signes Physiques Courants:**
    *   Fatigue, manque d'énergie
    *   Troubles du sommeil (insomnie ou hypersomnie)
    *   Changements d'appétit ou de poids
    *   Douleurs physiques inexpliquées
    \n\n**Signes Comportementaux Courants:**
    *   Retrait social
    *   Difficulté de concentration, prise de décision
    *   Agitation ou ralentissement psychomoteur
    \n\nSi vous ou quelqu'un que vous connaissez présentez plusieurs de ces symptômes pendant plus de deux semaines, il est crucial de consulter un médecin ou un professionnel de la santé mentale.
            ''', // Add more detailed markdown/text content here
      imageUrl:
          'https://images.pexels.com/photos/4098228/pexels-photo-4098228.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      estimatedReadTime: const Duration(minutes: 6),
    ),
    LearningArticle(
      id: 'learn_stress_01',
      title: 'Le Lien entre le Stress Chronique et la Santé Physique',
      category: 'Gestion du Stress',
      author: 'Association Médicale Américaine',
      summary:
          'Explorez comment le stress prolongé peut impacter votre corps, augmentant les risques de divers problèmes de santé.',
      fullContent: '''
    Le stress est une réaction normale, mais lorsqu'il devient chronique, il peut avoir des effets néfastes sur la santé physique. Le corps reste en état d'alerte élevé (réponse "combat ou fuite").
    \n\n**Impacts Potentiels du Stress Chronique:**
    *   **Système Cardiovasculaire:** Augmentation de la pression artérielle, risque accru de maladies cardiaques.
    *   **Système Immunitaire:** Affaiblissement des défenses, augmentation de la susceptibilité aux infections.
    *   **Système Digestif:** Problèmes comme le syndrome de l'intestin irritable (SII), reflux acide.
    *   **Santé Mentale:** Augmentation du risque d'anxiété, de dépression, de troubles du sommeil.
    *   **Autres:** Tensions musculaires, maux de tête, problèmes de peau.
    \n\nIl est essentiel de développer des stratégies de gestion du stress (relaxation, exercice, limites saines) pour protéger sa santé globale.
            ''', // Add more detailed markdown/text content here
      // No image for this one
      estimatedReadTime: const Duration(minutes: 4),
    ),
  ];
});
