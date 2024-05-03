library article_viewmodel_tests;

import 'package:articles_reader/domain/models/articles_result.dart';
import 'package:articles_reader/screens/articles_list/view_models/articles.viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_articles_repository.dart';
import '../../mocks/mock_callback_function.dart';

void main() {
  late ArticleViewModel viewModel;
  final MockCallbackFunction callbackFunction = MockCallbackFunction();

  setUp(() {
    viewModel = ArticleViewModel(
        repository: MockArticlesRepository(forceError: false));
    viewModel.addListener(() {
      callbackFunction.call();
    });
    reset(callbackFunction);
  });

  test('Get all articles from repo to show to the screen', () async {
    viewModel.getArticles();
    verify(callbackFunction.call()).called(2);
    expect(viewModel.articleResult.articles?.length, 2);
  });

  test('Loading is changing the state properly', () async {
    viewModel.setLoading(true);
    verify(callbackFunction.call()).called(2);
    expect(viewModel.loading, true);
  });

  test('Save the article in DB for favorites', () async {
    Article article = Article(
        source: Source(id: null, name: 'Google'),
        author: 'Darth Vader',
        title: 'Star Wars',
        description: 'The death star is approaching to the next objective',
        url: 'url 1',
        urlToImage: 'https://c.biztoc.com/p/ade97f459721643a/s.webp');
    viewModel.saveArticle(article, (result) {
      expect(result, isNonNegative);
    });
  });
}
