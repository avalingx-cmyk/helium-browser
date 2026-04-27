import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double progress;

  const LoadingIndicator({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress > 0 ? progress : null,
      minHeight: 2,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
