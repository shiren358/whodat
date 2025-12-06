import 'package:flutter/material.dart';
import 'dummy_data_generator.dart';

/// This script can be used to populate the app with dummy data.
///
/// Usage:
/// 1. Import this file in your main.dart or any other entry point
/// 2. Call DummyDataGenerator.generateDummyData() to populate data
/// 3. Call DummyDataGenerator.clearAllData() to clear all existing data
///
/// Example usage in main.dart:
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Uncomment the line below to populate with dummy data
///   // await DummyDataGenerator.generateDummyData();
///
///   // Uncomment the line below to clear all data first
///   // await DummyDataGenerator.clearAllData();
///
///   runApp(MyApp());
/// }
/// ```

/// Quick test function to verify the dummy data generation
Future<void> testDummyDataGeneration() async {
  debugPrint('=== Testing Dummy Data Generation ===');

  // Clear existing data first
  await DummyDataGenerator.clearAllData();

  // Generate new dummy data
  await DummyDataGenerator.generateDummyData();

  debugPrint('=== Test completed ===');
}