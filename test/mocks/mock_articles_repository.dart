import 'package:articles_reader/domain/models/articles_result.dart';
import 'package:articles_reader/screens/articles_list/repositories/articles_repository.dart';
import 'package:articles_reader/utils/api_status_codes.dart';
import 'package:articles_reader/utils/constants.dart';

class MockArticlesRepository extends ArticleRepository {
  bool forceError = false;
  List<Article> savedArticles = [
    Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title 1',
        description: 'Description 1',
        url: 'url 1',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp'),
    Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title 2',
        description: 'Description 2',
        url: 'url 2',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp')
  ];
  ArticlesResult articlesResult =
      ArticlesResult(status: 'ok', totalResults: 2, articles: [
    Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title test 1',
        description: 'Description 1',
        url: 'url 1',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp'),
    Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title test 2',
        description: 'Description 2',
        url: 'url 1',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp')
  ]);

  MockArticlesRepository({required this.forceError});

  @override
  Future<Object> fetchArticles() async {
    if (forceError) {
      return Failure(code: unknownError, errorResponse: 'Unknown Error');
    } else {
      return Success(code: 200, response: articlesResult);
    }
  }

  @override
  Future<List<Article>> getSavedArticles() async {
    if (forceError) {
      return [];
    } else {
      return savedArticles;
    }
  }

  @override
  saveArticle(Article article, Function(int result) onSuccess) {
    if (forceError) {
      onSuccess(-1);
    } else {
      savedArticles.add(article);
      onSuccess(article.title.hashCode);
    }
  }

  @override
  deleteArticle(int id) {
    if (!forceError) {
      for (var element in savedArticles) {
        if (element.title.hashCode == id) {
          savedArticles.remove(element);
          break;
        }
      }
    }
  }
}
