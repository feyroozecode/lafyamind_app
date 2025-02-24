import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';

import '../../../../core/common_import.dart';

class DailyWidget extends StatefulHookConsumerWidget {
  const DailyWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DailyWidgetState();
}

class _DailyWidgetState extends ConsumerState<DailyWidget> {
  @override
  Widget build(BuildContext context) {
    // final dailyData = ref.watch(dailyDataProvider);

    return Card(
        margin: screenPadding,
        child: Padding(
          padding: screenPadding,
          child: Column(
            children: [
              Text(
                'Today',
                style: context.theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),

              /// barre d'anxiety avec des EMOJIE

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Period',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    //dailyData.period
                    'Yes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Anxiety',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    //dailyData.anxietyLevel,
                    "Level 3/5",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ));
  }
}
