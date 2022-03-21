import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:learn_flutter_app/api/character_api.dart';
import 'package:learn_flutter_app/model/character.dart';
import 'package:learn_flutter_app/constant/view_state.dart';
import 'package:learn_flutter_app/model/detail_page_argument.dart';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _scrollController = ScrollController();

  ViewState _viewState = ViewState.empty;
  int _page = 1;
  bool _hasMore = false;
  List<Character> _characters = [];
  final Map<int, bool> _favorites = {};

  @override
  void initState() {
    super.initState();
    _fetchInitData();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        _fetchMoreData();
      }
    });
  }

  Future _onRefresh() async {
    _fetchInitData();
  }

  void _fetchInitData() async {
    if (_viewState == ViewState.loading) return;

    setState(() {
      _viewState = ViewState.loading;
      _page = 1;
      _characters = [];
    });

    final data = await CharacterApi.fetchCharacters(page: _page);

    setState(() {
      _viewState = data.isEmpty ? ViewState.empty : ViewState.dataLoaded;
      _page++;
      _hasMore = data.length >= CharacterApi.limit;
      _characters = data;
    });
  }

  Future _fetchMoreData() async {
    if (_viewState == ViewState.loading || _hasMore == false) return;

    final data = await CharacterApi.fetchCharacters(page: _page);

    setState(() {
      _viewState = ViewState.dataLoaded;
      _page++;
      _hasMore = data.length >= CharacterApi.limit;
      _characters.addAll(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#24282F"),
      appBar: AppBar(
        title: const Text(
          'Rick and Morty Characters',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: HexColor("#202329"),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _buildViewState(),
      ),
    );
  }

  Widget _buildViewState() {
    switch (_viewState) {
      case ViewState.loading:
        return _buildLoadingState();
      case ViewState.empty:
        return _buildEmptyState();
      default:
        return _buildLoadedState();
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState() {
    return Container();
  }

  Widget _buildLoadedState() {
    final characters = _characters;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildFavoriteItem(),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: characters.length + 1, // +1 for handle view load more
            itemBuilder: (context, index) {
              if (index < characters.length) {
                final character = characters[index];
                return _buildCharacterItem(character);
              } else {
                return _buildLoadMoreItem();
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildFavoriteItem() {
    final filteredFavorites = Map.from(_favorites)..removeWhere((k, v) => !v);
    return Container(
      padding: const EdgeInsets.all(16),
      color: HexColor("#24282F"),
      child: Text(
        'Total of favorite characters: ${filteredFavorites.values.length}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCharacterItem(Character character) {
    final isFavorited = _favorites[character.id] ?? false;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: HexColor('#3C3E44'),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(character.image),
      ),
      title: Text(
        character.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        '${character.status} - ${character.species}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      trailing: isFavorited
          ? const Icon(
              Icons.favorite,
              color: Colors.redAccent,
              size: 18,
            )
          : null,
      onTap: () => _onTapItem(character),
    );
  }

  void _onTapItem(Character character) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          argument: DetailPageArgument(
            character,
            _favorites[character.id] ?? false,
          ),
        ),
      ),
    );

    final argument = result as DetailPageArgument;
    setState(() {
      _favorites[argument.character.id] = argument.isFavorited;
    });
  }

  Widget _buildLoadMoreItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: _hasMore
            ? const CircularProgressIndicator()
            : const Text('No more data to load'),
      ),
    );
  }
}
