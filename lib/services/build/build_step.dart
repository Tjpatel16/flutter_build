import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/build_output.dart';

abstract class BuildStep {
  final Ref ref;
  
  BuildStep(this.ref);
  
  Future<void> execute({
    required String workingDir,
    required void Function(String output, BuildOutputType type) addOutput,
  });
}
