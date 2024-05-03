import 'dart:async';
import 'package:articles_reader/domain/models/articles_result.dart';
import 'package:articles_reader/screens/articles_list/view_models/articles.viewmodel.dart';
import 'package:articles_reader/widgets/image_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../widgets/loading_utils.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late final AppLifecycleListener _listener;
  late ArticleViewModel viewModel;
  late Timer timer;
  late final List<Widget> actionsAppBar = List.empty(growable: true);

  @override
  void initState() {
    createTimer();
    if (!kIsWeb) {
      actionsAppBar.add(Builder(builder: (context) =>
          IconButton(onPressed: () {
            Navigator.pushNamed(context, '/favorites');
          }, icon: const Icon(Icons.favorite_border))));
    }
    _listener = AppLifecycleListener(onStateChange: _onStateChange);
    super.initState();
  }

  void createTimer() {
    timer = Timer.periodic(
        const Duration(minutes: 15),
            (timer) =>
            setState(() {
              viewModel.getArticles();
            }));
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  _onStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!timer.isActive) createTimer();
        break;
      default:
        if (timer.isActive) timer.cancel();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ArticleViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        foregroundColor: Colors.white,
        actions: actionsAppBar,
      ),
      body: Column(
        children: [createUI()],
      ),
    );
  }

  Widget createUI() {
    if (viewModel.loading) {
      return progressIndicator("Loading...");
    }
    return Expanded(
        child: ListView.builder(
            itemBuilder: (context, index) {
              var article = viewModel.articleResult.articles?[index];
              if (article != null) {
                return builderForArticleList(
                    article,
                        () =>
                        viewModel.saveArticle(article, (result) {
                          Fluttertoast.showToast(
                              msg: result != -1
                                  ? 'The article ${article
                                  .title} was marked as favorite'
                                  : 'An error occurred trying to save the article');
                        }));
              } else {
                return const Text("No data to show");
              }
            },
            itemCount: viewModel.articleResult.articles?.length ?? 0));
  }

  Widget builderForArticleList(Article article, Function onILikeIt) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail',
            arguments: {'article': article});
      },
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 6.0,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              child: RoundedImage(image: article.urlToImage ?? ""),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(article.title ?? ""),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(article.description ?? ""),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: favButton("I like it", onILikeIt),
            )
          ],
        ),
      ),
    );
  }

  Widget favButton(String text, Function pressed) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, size: 18.0, color: Colors.red),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.black))
        ],
      ),
      onPressed: () => {pressed()},
    );
  }
}
