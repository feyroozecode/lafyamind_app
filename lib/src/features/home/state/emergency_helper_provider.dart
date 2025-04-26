
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/emergency_contact.dart';
import '../presentation/widgets/emergency_help_card.dart';

final emergencyContactListProvider = StateProvider<List<EmergencyContact>>((ref) {
  return [
  EmergencyContact(
    name: 'SOS 227',
    phoneNumber: '227-99-46-35-94',
    type: 'hotline',
  ),
  EmergencyContact(
    name: 'SAMU SOS',
    phoneNumber: '1515',
    type: 'emergency',
  ),
];

});

final emergencyContactsProvider = Provider<List<EmergencyContact>>((ref) {
  return ref.watch(emergencyContactListProvider).reversed.toList();
});

// Provider for tracking if user is in crisis mode
final inCrisisModeProvider = StateProvider<bool>((ref) => false);
