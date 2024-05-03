import 'dart:async';

import 'package:articles_reader/domain/db/database_arcticles.dart';
import 'package:articles_reader/domain/models/articles_result.dart';

class MockDatabase extends DbHelper {
  bool shouldReturnError = false;
  Map<int, Article> articles = <int, Article>{};

  MockDatabase(this.shouldReturnError) {
    articles['Title 1'.hashCode] = Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title 1',
        description: 'Description 1',
        url: 'url 1',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp');
    articles['Title 2'.hashCode] = Article(
        source: Source(id: null, name: 'Google'),
        author: 'test',
        title: 'Title 2',
        description: 'Description 2',
        url: 'url 2',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp');
  }

  @override
  Future<int> deleteArticle(int id) async {
    if (shouldReturnError) {
      return -1;
    } else {
      if (articles.containsKey(id)) {
        articles.remove(id);
        return id;
      } else {
        return -1;
      }
    }
  }

  @override
  Future<List> getAllArticles() async {
    if (shouldReturnError) {
      return [];
    } else {
      if (articles.isNotEmpty) {
        List<Map<dynamic,dynamic>> list = List.empty(growable: true);
        for (var element in articles.values) {
          list.add(element.toMap());
        }
        return list;
      } else {
        return [];
      }
    }
  }

  @override
  Future<Article?> getArticle(int id) async {
    if (shouldReturnError) {
      return null;
    } else {
      if (articles.containsKey(id)) {
        return articles[id];
      } else {
        return null;
      }
    }
  }

  @override
  Future<int?> getCount() async {
    return articles.length;
  }

  @override
  Future<int> saveArticle(Article article) async {
    if (shouldReturnError) {
      return -1;
    } else {
      articles[article.title.hashCode] = article;
      return article.title.hashCode;
    }
  }

  @override
  Future close() async {}

  @override
  Future deleteAllArticles() async {
    articles = <int, Article>{};
  }
}
