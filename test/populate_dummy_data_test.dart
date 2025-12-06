import 'package:flutter_test/flutter_test.dart';
import '../lib/utils/dummy_data_generator.dart';

/// Test file to populate the whodat app with dummy data
///
/// To run this test and populate the data:
/// 1. Open terminal in the whodat project root
/// 2. Run: flutter test test/populate_dummy_data_test.dart
///
/// This will generate 100 Person records with associated MeetingRecords
/// in the app's local storage (SharedPreferences).
void main() {
  testWidgets('Populate dummy data for whodat app', (WidgetTester tester) async {
    // Test description
    print('Starting dummy data generation for whodat app...\n');

    // Clear any existing data
    print('Clearing existing data...');
    await DummyDataGenerator.clearAllData();

    // Generate new dummy data
    print('\nGenerating new dummy data...');
    await DummyDataGenerator.generateDummyData();

    print('\n✅ Dummy data generation completed successfully!');
    print('You can now run the app to see the populated data.');

    // Test passes
    expect(true, isTrue);
  });
}