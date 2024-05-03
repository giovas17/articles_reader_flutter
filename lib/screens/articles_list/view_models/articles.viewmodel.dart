import 'package:articles_reader/screens/articles_list/repositories/articles_repository.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/articles_result.dart';
import '../../../utils/api_status_codes.dart';

class ArticleViewModel extends ChangeNotifier {
  bool _loading = false;
  ArticlesResult? _articlesResult;

  late ArticleRepository repository;

  ArticleViewModel({required this.repository}) {
    getArticles();
  }

  bool get loading => _loading;
  ArticlesResult get articleResult => _articlesResult ?? ArticlesResult();

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setArticleResult(ArticlesResult result) async {
    _articlesResult = result;
  }

  getArticles() async {
    setLoading(true);
    var response = await repository.fetchArticles();
    if (response is Success) {
      setArticleResult(response.response as ArticlesResult);
    }
    setLoading(false);
  }

  saveArticle(Article article, Function(int result) onSuccess) async {
    repository.saveArticle(article, onSuccess);
  }

}