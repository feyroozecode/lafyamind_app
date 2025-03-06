import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_size.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../domain/emergency_contact.dart';
import '../providers/emergency_helper_provider.dart';

// Static emergency contacts for testing
class EmergencyHelpCard extends ConsumerWidget {
  const EmergencyHelpCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inCrisisMode = ref.watch(inCrisisModeProvider);
    final contacts = ref.watch(emergencyContactsProvider);

    return Card(
      elevation: 8,
      color: inCrisisMode ? Colors.red.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: inCrisisMode ? Colors.red : Colors.grey.shade300,
          width: inCrisisMode ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emergency,
                  color: inCrisisMode ? Colors.red : Colors.grey,
                  size: 28,
                ),
                gapH12,
                Expanded(
                  child: Text(
                    'Voulez-vous parler à un conseiller en crise maintenant ?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: inCrisisMode ? Colors.red : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            gapH16,
            Text(
              'Nous sommes là pour vous aider. Connectez-vous avec un conseiller en crise maintenant.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            gapH16,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(inCrisisModeProvider.notifier).state = true;
                  _showEmergencyDialog(context, contacts);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Parler à quelqu\'un maintenant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            gapH12,
            const EmergencyResourcesList(),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context, List<EmergencyContact> contacts) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('URGENT! 🆘 '),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Comment souhaitez-vous que nous vous aidions ?",
              style: TextStyle(fontSize: 16),
            ),
            gapH16,
            ...contacts.map((contact) => _buildContactButton(context, contact)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(BuildContext context, EmergencyContact contact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(
            contact.type == 'hotline' ? Icons.phone : Icons.emergency,
            color: Colors.white,
          ),
          label: Text(contact.name),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            // Implement phone call functionality
            // You would typically use url_launcher package here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Appel en cours vers ${contact.name}...')),
            );
           Future.delayed(Duration(seconds: 2), () {
              launchUrlString('tel:${0022799463594}');
           });
          },
        ),
      ),
    );
  }
}

class EmergencyResourcesList extends StatelessWidget {
  const EmergencyResourcesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ressources rapides :',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        gapH8,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildResourceChip(context, 'Exercice de respiration', Icons.air),
            _buildResourceChip(context, 'Techniques d\'ancrage', Icons.spa),
            _buildResourceChip(context, 'Plan de crise', Icons.checklist),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceChip(BuildContext context, String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: () {
        // Implement resource navigation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ouverture de $label...')),
        );
      },
    );
  }
}