import 'dart:convert';
import 'dart:io';
import 'package:articles_reader/domain/db/database_arcticles.dart';
import '../../../domain/models/articles_result.dart';
import '../../../utils/api_status_codes.dart';
import '../../../utils/constants.dart';
import 'package:http/http.dart' as http;

abstract class ArticleRepository {
  Future<Object> fetchArticles();

  saveArticle(Article article, Function(int result) onSuccess);

  Future<List<Article>> getSavedArticles();

  deleteArticle(int id);
}

class ArticleRepositoryImpl extends ArticleRepository {
  late DbHelper database;
  late http.Client client;

  ArticleRepositoryImpl({required this.database}) : client = http.Client();
  ArticleRepositoryImpl.test({required this.database, required this.client});

  @override
  Future<Object> fetchArticles() async {
    try {
      final response = await client.get(Uri.parse(newsUrl));
      if (response.statusCode == 200) {
        final result = ArticlesResult.fromJson(json.decode(response.body));
        return Success(code: response.statusCode, response: result);
      }
      return Failure(code: invalidResponse, errorResponse: "Invalid Response");
    } on HttpException {
      return Failure(code: noInternet, errorResponse: "No internet");
    } on FormatException {
      return Failure(
          code: invalidFormat, errorResponse: "Invalid format response");
    } catch (e) {
      return Failure(code: unknownError, errorResponse: "Unknown error");
    }
  }

  @override
  saveArticle(Article article, Function(int result) onSuccess) async {
    database.saveArticle(article).then((value) => onSuccess(value));
  }

  @override
  Future<List<Article>> getSavedArticles() async {
    List<Article> list = List.empty(growable: true);
    await database.getAllArticles().then((value) async {
      for (var element in value) {
        list.add(Article.fromMap(element));
      }
    });
    return list;
  }

  @override
  deleteArticle(int id) async {
    database.deleteArticle(id);
  }
}
