import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:learn_flutter_app/model/character.dart';
import 'package:learn_flutter_app/model/detail_page_argument.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.argument}) : super(key: key);

  final DetailPageArgument argument;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Character _character;

  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _character = widget.argument.character;
    _isFavorited = widget.argument.isFavorited;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onTapBack(context),
      child: Scaffold(
        backgroundColor: HexColor("#24282F"),
        appBar: AppBar(
          title: Text(
            _character.name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: HexColor("#202329"),
        ),
        body: _buildCharacter(_character),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onTapFab(),
          tooltip: 'Increment',
          child: Icon(
            _isFavorited ? Icons.favorite : Icons.favorite_outline,
            color: _isFavorited ? Colors.redAccent : HexColor("#24282F"),
          ),
        ),
      ),
    );
  }

  Widget _buildCharacter(Character character) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              character.image,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            character.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(
          color: Colors.white,
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildText('Status', character.status),
            const SizedBox(height: 16),
            _buildText('Species', character.species),
            const SizedBox(height: 16),
            _buildText('Gender', character.gender),
            const SizedBox(height: 16),
            _buildText('Origin', character.origin.name),
            const SizedBox(height: 16),
            _buildText('Location', character.location.name),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildText(String title, String value) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Text(
                ':',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _onTapFab() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  bool _onTapBack(BuildContext context) {
    final result = DetailPageArgument(_character, _isFavorited);
    Navigator.of(context).pop(result);
    return false;
  }
}
