library articles_repository_tests;

import 'dart:convert';
import 'dart:io';

import 'package:articles_reader/domain/models/articles_result.dart';
import 'package:articles_reader/screens/articles_list/repositories/articles_repository.dart';
import 'package:articles_reader/utils/api_status_codes.dart';
import 'package:articles_reader/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'articles_repository_tests.mocks.dart';
import '../../mocks/mock_database.dart';

@GenerateMocks([http.Client])
void main() {
  late ArticleRepository repository;
  var client = MockClient();

  setUp(() {
    repository = ArticleRepositoryImpl.test(
        database: MockDatabase(false), client: client);
  });

  test('Fetch articles from API', () async {
    when( client.get(Uri.parse(newsUrl)) ).thenAnswer((_) async {
      var data = await File('test/assets/article_results.json').readAsString(encoding: latin1);
      return http.Response(data, 200);
    });
    var result = await repository.fetchArticles();
    final articleResult = (result as Success).response as ArticlesResult;
    expect(articleResult.articles?.length, 5);
  });

  test('Fetch articles from API with an error of Invalid response', () async {
    when( client.get(Uri.parse(newsUrl)) ).thenAnswer((_) async {
      return http.Response('Invalid response', 404);
    });
    var result = await repository.fetchArticles();
    final articleResult = (result as Failure).code;
    expect(articleResult, invalidResponse);
  });

  test('Fetch articles from API with an error of No Internet', () async {
    when( client.get(Uri.parse(newsUrl)) ).thenAnswer((_) async {
      throw const HttpException('something went wrong with connection');
    });
    var result = await repository.fetchArticles();
    final articleResult = (result as Failure).code;
    expect(articleResult, noInternet);
  });

  test('Mark as favorite one article', () async {
    Article article = Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title test',
        description: 'Description 1',
        url: 'url 1',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp');
    repository.saveArticle(article, (result) {
      expect(result, isNonNegative);
    });
  });

  test('Get all the favorites', () async {
    Article article = Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title test',
        description: 'Description 1',
        url: 'url 1',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp');
    repository.saveArticle(article, (result) {});
    var list = await repository.getSavedArticles();
    expect(list.length, 3);
  });

  test('Delete a favorite', () async {
    Article article = Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title test 10',
        description: 'Description 1',
        url: 'url 1',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp');
    repository.saveArticle(article, (result) {});
    repository.deleteArticle(article.title.hashCode);
    var list = await repository.getSavedArticles();
    expect(list.length, 2);
  });
}
