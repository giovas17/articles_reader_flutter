import 'domain/repos/articles_repository_tests.dart' as art_repo_tests;
import 'domain/data/database_tests.dart' as database_tests;
import 'domain/view_models/article_viewmodel_tests.dart' as article_viewmodel_tests;
import 'domain/view_models/favorites_viewmodel_tests.dart' as favs_viewmodel_test;

void main() {
  art_repo_tests.main();
  database_tests.main();
  article_viewmodel_tests.main();
  favs_viewmodel_test.main();
}