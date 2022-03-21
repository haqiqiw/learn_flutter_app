import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:learn_flutter_app/model/result_character.dart';
import 'package:learn_flutter_app/model/character.dart';

class CharacterApi {
  static const _baseUrl = 'https://rickandmortyapi.com/api/';
  static const limit = 20;

  static Future<List<Character>> fetchCharacters({required int page}) async {
    final url = '${_baseUrl}character/?page=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(_parseCharacters, response.body);
    } else {
      return [];
    }
  }

  static List<Character> _parseCharacters(String responseBody) {
    final parsed = ResultCharacter.fromJson(jsonDecode(responseBody));
    return parsed.results;
  }
}
