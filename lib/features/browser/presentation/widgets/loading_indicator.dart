import 'package:flutter/material.dart';

// CONST AUDIT: ✅ Can be const - no dynamic dependencies.
// This widget rebuilds only when `progress` changes.
class LoadingIndicator extends StatelessWidget {
  final double progress;

  const LoadingIndicator({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    // PERFORMANCE: Progress bar wrapped in RepaintBoundary to prevent
    // entire screen repaint when progress updates.
    return RepaintBoundary(
      child: LinearProgressIndicator(
      value: progress > 0 ? progress : null,
      minHeight: 2,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.primary,
      ),
    ),
    );
  }
}
