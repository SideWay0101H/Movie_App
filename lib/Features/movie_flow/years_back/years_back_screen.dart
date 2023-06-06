import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/Features/movie_flow/movie_flow_controller.dart';
import 'package:movie_app/Features/movie_flow/result/result_screen.dart';
import 'package:movie_app/core/constants.dart';
import 'package:movie_app/core/widgets/primary_buttons.dart';

class YearsBackScreen extends ConsumerWidget {
  const YearsBackScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed:
              ref.read(movieFlowControllerProvider.notifier).previousPage,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'How many years back should we check for?',
              style: theme.textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${ref.watch(movieFlowControllerProvider).yearsBack}',
                  style: theme.textTheme.headline2,
                ),
                Text(
                  'Years back',
                  style: theme.textTheme.headline4?.copyWith(
                      color:
                          theme.textTheme.headline4?.color?.withOpacity(0.62)),
                ),
              ],
            ),
            const Spacer(),
            Slider(
              onChanged: (value) {
                ref
                    .read(movieFlowControllerProvider.notifier)
                    .updateYearBack(value.toInt());
              },
              value:
                  ref.watch(movieFlowControllerProvider).yearsBack.toDouble(),
              min: 0,
              max: 65,
              divisions: 65,
              label: '${ref.watch(movieFlowControllerProvider).yearsBack}',
            ),
            const Spacer(),
            PrimaryButton(
                onPressed: () async {
                  await ref
                      .read(movieFlowControllerProvider.notifier)
                      .getRecommandMovie();
                  Navigator.of(context).pop(ResultScreen.route());
                },
                isLoading: ref.watch(movieFlowControllerProvider).movie is AsyncLoading,
                text: 'Amazing'
                ),
                const SizedBox(height: KMediumSpacing),
          ],
        ),
      ),
    );
  }
}
