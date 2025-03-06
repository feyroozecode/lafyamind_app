import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';
import 'package:lafyamind_app/src/features/home/core/presentation/providers/home_provider.dart';
import 'package:lafyamind_app/src/features/home/core/presentation/widgets/daily_widget.dart';
import 'package:lafyamind_app/src/features/home/core/presentation/widgets/emergency_help_card.dart';
import 'package:lafyamind_app/src/features/home/core/presentation/widgets/mood_tracker_card.dart';

import '../../../../core/common_import.dart';
import 'day_homour_widget.dart';

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
        child: SingleChildScrollView(
          child:  Column(
          children: [
            Text(
                'Un bon retour cher ${loclaUserProvider?.name} !',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapH12,
            const MoodTrackerCard(), 
            gapH12,
            const EmergencyHelpCard(),
        
          ]
            // OLD DayHomourWidget()],
        ),
        )
        );
  }
}
