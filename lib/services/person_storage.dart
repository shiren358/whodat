import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person.dart';

class PersonStorage {
  static const String _key = 'persons';

  static Future<void> savePerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();
    final persons = await getAllPersons();
    persons.add(person);

    final jsonList = persons.map((p) => p.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<Person>> getAllPersons() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Person.fromJson(json)).toList();
  }

  static Future<void> updatePerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();
    final persons = await getAllPersons();

    final index = persons.indexWhere((p) => p.id == person.id);
    if (index != -1) {
      persons[index] = person;
      final jsonList = persons.map((p) => p.toJson()).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
    }
  }

  static Future<void> deletePerson(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final persons = await getAllPersons();

    persons.removeWhere((p) => p.id == id);
    final jsonList = persons.map((p) => p.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }
}
