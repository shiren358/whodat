# Dummy Data Generator for Whodat App

This document explains how to populate the Whodat app with 100 dummy records for testing purposes.

## Overview

The dummy data generator creates:
- **100 Person records** with realistic Japanese names, companies, positions, and tags
- **100-300 MeetingRecord entries** (1-3 meetings per person) with realistic locations and dates

## Features

### Person Records Include:
- Realistic Japanese names (surname + given name combinations)
- Real Japanese companies (Toyota, Sony, SoftBank, etc.) and fictional companies
- Various job positions and titles
- Random tags from a pool of 80+ skills, industries, and interests
- Avatar colors from the existing app palette
- Meeting dates spread over the past 2 years

### MeetingRecord Entries Include:
- Locations with GPS coordinates for major Japanese cities (Tokyo, Osaka, etc.)
- Manual entries for common meeting spots (hotels, conference centers, cafes)
- Realistic meeting notes related to business activities
- Varying meeting dates to avoid duplicates

## How to Use

### Method 1: Run Test File (Recommended)

1. Open terminal in the whodat project root
2. Run the test:
   ```bash
   flutter test test/populate_dummy_data_test.dart
   ```
3. Wait for the generation to complete (usually takes a few seconds)
4. Run the app normally to see the populated data

### Method 2: Integrate into Main App

1. Open `lib/main.dart`
2. Import the dummy data generator:
   ```dart
   import 'utils/dummy_data_generator.dart';
   ```
3. Add these lines before `runApp(const MyApp());`:
   ```dart
   // Uncomment to populate with dummy data (run once)
   // await DummyDataGenerator.generateDummyData();

   // Uncomment to clear all data first
   // await DummyDataGenerator.clearAllData();
   ```
4. Uncomment the desired line and run the app
5. Comment out the line again after populating to avoid regenerating data

## File Structure

```
lib/
├── utils/
│   ├── dummy_data_generator.dart    # Main generator class
│   └── populate_dummy_data.dart     # Helper utilities
test/
└── populate_dummy_data_test.dart    # Test runner (Method 1)
```

## Data Sources

### Japanese Names
- Common surnames: 佐藤, 鈴木, 高橋, etc.
- Common given names: 誠, 結衣, 拓也, etc.

### Companies
- Major Japanese corporations: Toyota, Sony, SoftBank, etc.
- Banks: MUFG, SMBC, Mizuho
- Tech companies: CyberAgent, Mercari, LINE
- Fictional companies for variety

### Locations
- GPS coordinates for major stations and venues
- Manual entries for hotels, conference centers, cafes
- Coverage across major Japanese cities

### Tags
- Business skills: Marketing, Consulting, Project Management
- Technologies: AI, Blockchain, Cloud Computing
- Industries: FinTech, HealthTech, SaaS
- Languages: English, Chinese, Korean

## Notes

- The generator ensures no duplicate name/company combinations
- Meeting dates are randomly distributed over the past 2 years
- Each person gets 1-3 meeting records
- Data is stored using SharedPreferences (same as the real app)
- You can clear all data using `DummyDataGenerator.clearAllData()`

## Troubleshooting

If the data doesn't appear:
1. Make sure you fully completed the test/run
2. Restart the app
3. Check the console for any error messages
4. Try clearing and regenerating the data

## Data Sample

Generated data looks like:
- Person: "佐藤 誠" from "トヨタ自動車" as "営業部長"
- Tags: ["営業", "自動車", "マーケティング"]
- Meeting: "東京駅丸の内" on 2024.03.15 with "新規事業の協力について協議"