import 'package:flutter/material.dart';
import 'package:flutter_build/screens/widgets/app_icon_generator/start_generate_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/home/home_provider.dart';
import '../text_widget.dart';
import 'app_icon_mockup.dart';
import 'app_type_selection.dart';
import 'image_selection.dart';

class AppIconGenerator extends ConsumerWidget {
  const AppIconGenerator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    // Listen for project selection changes
    ref.listen(homeProvider, (previous, next) {
      if (next.hasValue &&
          next.value?.selectedProjectPath !=
              previous?.value?.selectedProjectPath &&
          next.value?.selectedProjectPath != null) {}
    });

    return homeState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: TextWidget(
          error.toString(),
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      data: (state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Opacity(
            opacity: state.isValidProject ? 1.0 : 0.5,
            child: AbsorbPointer(
              absorbing: state.selectedProjectPath == null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ImageSelection(),
                  const SizedBox(height: 20),
                  AppTypeSelection(),
                  const SizedBox(height: 20),
                  StartGenerateButton(),
                  const SizedBox(height: 20),
                  AppIconMockup(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
