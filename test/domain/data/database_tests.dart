library database_tests;

import 'package:articles_reader/domain/db/database_arcticles.dart';
import 'package:articles_reader/domain/models/articles_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  late DbHelper helper;

  Article article = Article(
      source: Source(id: null, name: 'Google'),
      author: 'test',
      title: 'Title 1',
      description: 'Description 1',
      url: 'url 1',
      urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp');

  setUpAll(() async {
    helper = DbHelperImpl.test(isTesting: true);
  });

  tearDownAll(() async {
    await helper.close();
  });

  test('Mark an article as favorite', () async {
    var result = await helper.saveArticle(article);
    expect(result, isNonNegative);
    var list = await helper.getAllArticles();
    expect(list.length, 1);
  });

  test('Get All the Articles from DB', () async {
    Article secondArticle = Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title 2',
        description: 'Description 2',
        url: 'url 2',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp');
    await helper.saveArticle(article);
    await helper.saveArticle(secondArticle);
    var list = await helper.getAllArticles();
    expect(list.length, 2);
  });

  test('Get an specific article from DB', () async {
    await helper.saveArticle(article);
    var receivedArticle = await helper.getArticle(article.title.hashCode);
    expect(receivedArticle?.title, equals(article.title));
  });

  test('Get number of items in the DB', () async {
    await helper.deleteAllArticles();
    await helper.saveArticle(article);
    var number = await helper.getCount();
    expect(number, 1);
  });

  test('Get number of items when DB is empty', () async {
    await helper.deleteAllArticles();
    var number = await helper.getCount();
    expect(number, 0);
  });

  test('Delete an specific article from DB', () async {
    await helper.saveArticle(article);
    var result = await helper.deleteArticle(article.title.hashCode);
    expect(result, 1);
  });

}
