import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class MemoryMonitor extends StatelessWidget {
  final Widget child;

  const MemoryMonitor({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (!const bool.fromEnvironment('dart.vm.profile') &&
        !const bool.fromEnvironment('dart.vm.release')) {
      return Stack(
        children: [
          child,
          Positioned(
            top: 50,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Debug Mode',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }

  static void log(String message) {
    developer.log(message, name: 'MemoryMonitor');
  }
}
