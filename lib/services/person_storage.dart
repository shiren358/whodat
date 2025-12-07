import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/person.dart';

class PersonStorage {
  static const String _key = 'persons';
  static const _storage = FlutterSecureStorage();

  static Future<void> _savePersons(List<Person> persons) async {
    final jsonList = persons.map((p) => p.toJson()).toList();
    await _storage.write(key: _key, value: jsonEncode(jsonList));
  }

  static Future<void> savePerson(Person person) async {
    final persons = await getAllPersons();
    persons.add(person);
    await _savePersons(persons);
  }

  static Future<List<Person>> getAllPersons() async {
    final jsonString = await _storage.read(key: _key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Person.fromJson(json)).toList();
  }

  static Future<void> updatePerson(Person person) async {
    final persons = await getAllPersons();
    final index = persons.indexWhere((p) => p.id == person.id);
    if (index != -1) {
      persons[index] = person;
      await _savePersons(persons);
    }
  }

  static Future<void> deletePerson(String id) async {
    final persons = await getAllPersons();
    persons.removeWhere((p) => p.id == id);
    await _savePersons(persons);
  }
}
