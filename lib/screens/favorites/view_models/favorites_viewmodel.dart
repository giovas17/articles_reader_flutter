import 'package:articles_reader/domain/models/articles_result.dart';

import '../../articles_list/repositories/articles_repository.dart';

class FavoritesViewModel {
  List<Article> _favorites = List.empty(growable: true);
  late ArticleRepository repository;

  FavoritesViewModel({required this.repository});

  List<Article> get favorites => _favorites;

  setFavorites(List<Article> articlesSaved) async {
    _favorites = articlesSaved;
  }

  Future<List<Article>> getFavorites() async {
    setFavorites(await repository.getSavedArticles());
    return favorites;
  }

  Future deleteFavorite(int id) async {
    repository.deleteArticle(id);
  }

}