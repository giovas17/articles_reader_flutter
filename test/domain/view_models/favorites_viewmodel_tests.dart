library favs_viewmodel_test;

import 'package:articles_reader/screens/favorites/view_models/favorites_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mocks/mock_articles_repository.dart';

void main() {
  late FavoritesViewModel viewModel;

  setUp(() {
    viewModel = FavoritesViewModel(
        repository: MockArticlesRepository(forceError: false));
  });

  test('Get all favorite list', () async {
    var list = await viewModel.getFavorites();
    expect(list.length, 2);
  });

  test('Delete a favorite', () async {
    var list = await viewModel.getFavorites();
    await viewModel.deleteFavorite(list[0].title.hashCode);
    expect(viewModel.favorites.length, 1);
  });
}
