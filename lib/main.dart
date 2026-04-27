import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

// CONST AUDIT: ✅ Can be const - no dynamic dependencies.
// Entry point widget that wraps the entire app with ProviderScope.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: HeliumBrowserApp()));
}
