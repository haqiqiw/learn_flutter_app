import 'package:learn_flutter_app/model/character.dart';

class DetailPageArgument {
  final Character character;
  final bool isFavorited;

  DetailPageArgument(this.character, this.isFavorited);

  @override
  String toString() =>
      'Favorite{characterId={${character.id}}, isFavorited=$isFavorited}';
}
