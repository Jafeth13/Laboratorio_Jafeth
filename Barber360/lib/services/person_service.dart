import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class PersonService {
  static const String nodeUrl = 'http://localhost:3000/api/persons';
  static const String dotnetUrl = 'http://localhost:5000/api';

  Future<List<Person>> getAll() async {
    final res = await http.get(Uri.parse(nodeUrl));
    final data = jsonDecode(res.body);

    return (data['data'] as List)
        .map((e) => Person.fromJson(e))
        .toList();
  }

  Future<void> create(Person p) async {
    await http.post(
      Uri.parse(nodeUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "identification": p.identification,
        "name": p.name,
        "email": p.email,
        "birthDate": p.birthDate
      }),
    );
  }

  Future<void> update(Person p) async {
    await http.put(
      Uri.parse('$dotnetUrl/person/update'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": p.id,
        "identification": p.identification,
        "name": p.name,
        "email": p.email,
        "birthDate": p.birthDate
      }),
    );
  }

  Future<void> delete(int id) async {
    await http.delete(
      Uri.parse('$dotnetUrl/persons/delete/$id'),
    );
  }
}
