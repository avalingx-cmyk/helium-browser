import 'package:flutter/material.dart';

class TabSwitcherScreen extends StatelessWidget {
  const TabSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs'),
      ),
      body: const Center(
        child: Text('Tab switcher coming in Phase 2'),
      ),
    );
  }
}
