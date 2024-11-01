import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share/share.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({this.title,this.url});
  final String? url;
  final String? title;

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late InAppWebViewController _webViewController;
  bool canGoBack = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black),
      onPressed: () async {
        if (canGoBack) {
          _webViewController.goBack();
        } else {
          Navigator.pop(context);
        }
      },
    ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Image.asset("assets/new_box.png",height: 80.0),
          ],
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share,color: Colors.black),
            onPressed: () {
              Share.share(widget.url!);
            },
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url!),),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          bool canNavigateBack = await controller.canGoBack();
          setState(() {
            canGoBack = canNavigateBack;
          });
        },
      ),
    );
  }
}