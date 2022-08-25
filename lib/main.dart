import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWords extends StatefulWidget {
  const RandomWords ({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generador de Nombres"),
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
            tooltip: "Sugerencias guardadas",
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel:
                  alreadySaved ? "Quitar de los guardados" : "Guardar",
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
              (pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
          );
          final divided = tiles.isNotEmpty ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
          ).toList() : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text("Sugerencias Guardadas"),
            ),
            body: ListView(children: divided,),
          );
        }
      )
    );
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return const MaterialApp(
      title: 'Generador de Nombres',
      home: RandomWords()
    );
  }
}

