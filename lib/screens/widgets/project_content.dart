import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../riverpod/home/home_provider.dart';
import '../../riverpod/version/version_provider.dart';
import 'build_mode/build_mode_selection.dart';
import 'build_type/build_type_selection.dart';
import 'flutter_info/flutter_info_section.dart';
import 'project_selection.dart';
import 'start_build_button.dart';
import 'terminal/terminal_view.dart';
import 'text_widget.dart';
import 'version/version_management.dart';

class ProjectContent extends ConsumerWidget {
  const ProjectContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    // Listen for project selection changes
    ref.listen(homeProvider, (previous, next) {
      if (next.hasValue &&
          next.value?.selectedProjectPath !=
              previous?.value?.selectedProjectPath &&
          next.value?.selectedProjectPath != null) {
        ref
            .read(versionInfoProvider.notifier)
            .loadVersion(next.value!.selectedProjectPath!);
      }
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
      data: (state) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FlutterInfoSection(),
            const SizedBox(height: 24),
            const ProjectSelection(),
            const SizedBox(height: 24),
            Opacity(
              opacity: state.selectedProjectPath != null ? 1.0 : 0.5,
              child: AbsorbPointer(
                absorbing: state.selectedProjectPath == null,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    VersionManagement(),
                    SizedBox(height: 24),
                    BuildTypeSelection(),
                    SizedBox(height: 24),
                    BuildModeSelection(),
                    SizedBox(height: 24),
                    StartBuildButton(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const TerminalView(),
          ],
        ),
      ),
    );
  }
}
