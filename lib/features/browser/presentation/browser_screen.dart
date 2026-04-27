import 'package:flutter/material.dart';

class BrowserScreen extends StatelessWidget {
  const BrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helium Browser'),
      ),
      body: const Center(
        child: Text('WebView coming in Phase 1'),
      ),
    );
  }
}
