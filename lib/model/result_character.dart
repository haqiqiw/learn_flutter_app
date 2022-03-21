import 'info.dart';
import 'character.dart';

class ResultCharacter {
  ResultCharacter({
    required this.info,
    required this.results,
  });

  Info info;
  List<Character> results;

  factory ResultCharacter.fromJson(Map<String, dynamic> json) =>
      ResultCharacter(
        info: Info.fromJson(json["info"]),
        results: List<Character>.from(
            json["results"].map((x) => Character.fromJson(x))),
      );
}
