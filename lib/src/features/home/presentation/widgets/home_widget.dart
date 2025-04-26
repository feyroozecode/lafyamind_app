import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';
import 'package:lafyamind_app/src/features/home/state/home_provider.dart';
import 'package:lafyamind_app/src/features/home/presentation/widgets/emergency_help_card.dart';
import 'package:lafyamind_app/src/features/home/presentation/widgets/mood_tracker_card.dart';

import '../../../core/common_import.dart';
import '../../../feed/presentation/feed_screen.dart';

class HomeWidget extends StatefulHookConsumerWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    final loclaUserProvider = ref.watch(localUserDataProvider);

    return Padding(
      padding: screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Un bon retour cher ${loclaUserProvider?.name ?? 'Utilisateur'} !',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          gapH12,
          const MoodTrackerCard(),
          gapH12,
          const EmergencyHelpCard(),
          gapH12,
        ],
      ),
    );
  }
}
