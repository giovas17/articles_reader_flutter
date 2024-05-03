import 'package:articles_reader/domain/db/database_arcticles.dart';
import 'package:articles_reader/screens/article_detail/presentation/article_detail_screen.dart';
import 'package:articles_reader/screens/articles_list/presentation/articles_screen.dart';
import 'package:articles_reader/screens/articles_list/repositories/articles_repository.dart';
import 'package:articles_reader/screens/articles_list/view_models/articles.viewmodel.dart';
import 'package:articles_reader/screens/favorites/presentation/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ArticleViewModel>(
            create: (_) => ArticleViewModel(
                repository: ArticleRepositoryImpl(database: DbHelperImpl())))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ArticlesScreen(),
          '/detail': (context) => const ArticleDetailScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
      ),
    );
  }
}
