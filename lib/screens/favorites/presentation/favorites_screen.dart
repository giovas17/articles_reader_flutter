import 'package:articles_reader/domain/db/database_arcticles.dart';
import 'package:articles_reader/screens/articles_list/repositories/articles_repository.dart';
import 'package:articles_reader/screens/favorites/view_models/favorites_viewmodel.dart';
import 'package:articles_reader/widgets/image_utils.dart';
import 'package:articles_reader/widgets/loading_utils.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/articles_result.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoritesViewModel viewModel = FavoritesViewModel(
      repository: ArticleRepositoryImpl(database: DbHelperImpl()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Article>>(
        future: viewModel.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('There are no favorites'));
            }
            return ListView.builder(
                itemBuilder: favoriteRow,
                itemCount: snapshot.data?.length ?? 0);
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('There is an error loading the favorites'));
          }
          return progressIndicator('Loading...');
        },
      ),
    );
  }

  Widget favoriteRow(BuildContext context, int pos) {
    Article favorite = viewModel.favorites[pos];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail',
            arguments: {'article': favorite});
      },
      child: Card(
        margin: const EdgeInsets.all(5.0),
        elevation: 4.0,
        child: ListTile(
          title: Text(favorite.title ?? ''),
          subtitle: Text('Author: ${favorite.author}'),
          leading: NetImage(
              imageUrl: favorite.urlToImage ?? '',
              width: 50.0,
              aspectRatio: 16 / 9,
              background: Colors.white),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  viewModel.deleteFavorite(favorite.title.hashCode);
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
