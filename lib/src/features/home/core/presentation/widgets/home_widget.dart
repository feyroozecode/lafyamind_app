import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/constants/app_spacing.dart';
import 'package:lafyamind_app/src/features/home/core/presentation/widgets/daily_widget.dart';

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
    return Padding(
      padding: screenPadding,
      child: Column(
        children: const [DayHomourWidget(), DailyWidget()],
      ),
    );
  }
}
