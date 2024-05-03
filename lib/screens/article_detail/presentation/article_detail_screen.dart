import 'package:articles_reader/domain/models/articles_result.dart';
import 'package:articles_reader/widgets/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    Article article = arguments?['article'] as Article;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Article Detail'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NetImage(
                imageUrl: article.urlToImage ?? '',
                width: size.width,
                aspectRatio: 9 / 6),
            Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  article.title ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 4),
              child: Text(
                'Author: ${article.author ?? ''}',
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                'Published At: ${article.publishedAt ?? ''}',
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                article.description ?? '',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                article.content ?? '',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextButton(
                child: Text(
                  'Open the link for more information -> ${article.content ?? ''}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                onPressed: () async {
                  if (article.url != null) {
                    final Uri url = Uri.parse(article.url!);
                    if (!await launchUrl(url)) {
                      Fluttertoast.showToast(
                          msg: 'Is not possible to open the link');
                    }
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Source: ${article.source?.name ?? ''}',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
