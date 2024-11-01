import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:news_box/application/news_controller.dart';
import 'package:news_box/helper/data.dart';
import 'package:news_box/infra/news_repository.dart';
import 'package:news_box/modal/categoryModal.dart';
import 'package:news_box/modal/news_modal.dart';
import 'package:news_box/views/article_view.dart';
import 'package:news_box/views/feedback_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModal> categories= <CategoryModal>[];
  final NewsService _newsService = NewsService();
  NewsModal? data;
  bool _showFeedbackButton=false;
  @override
  void initState(){
    super.initState();

    categories=getCategoryModale();
    Timer(Duration(seconds: 30), () {
      setState(() {
        _showFeedbackButton = true;
      });
    });
  }
  // Future<void> _fetchNews() async {
  //   CupertinoActivityIndicator();
  //   await _newsService.fetchTopHeadlines();
  //    data=_newsService.dataModal;
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
           GestureDetector(
               onTap: (){
                 Get.to(FeedbackScreen());
               },
               child: Image.asset("assets/new_box.png",height: 80.0)),
          ],
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Stack(
          alignment: Alignment.bottomLeft ,
          children: [
            GetBuilder<NewsController>(
        builder: (controller) {
          return Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                          return CardCategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },),
                      ),
                     controller.isLoading?
                     Lottie.asset("assets/loading.json",):
                     controller.dataModal.articles?.length==0?
                     Lottie.asset("assets/no_data.json",):
                     Expanded(
                       flex: 4,
                        child: ListView.builder(
                          itemCount: controller.dataModal.articles?.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return BlogTile(
                              url: controller.dataModal.articles?[index].url,
                              imageUrl: controller.dataModal.articles?[index].urlToImage??"",
                              title:controller.dataModal.articles?[index].title??"",
                              description: controller.dataModal.articles?[index].description??"",
                            );
                          },),
                      ),
                    ],
                  ),
                ),
              );
        }
      ),
            _showFeedbackButton
                ?Row(
                  children: [
                    SizedBox(width: 8.0),
                    ElevatedButton(
              onPressed: () {
                Get.to(FeedbackScreen());
                    // Action when feedback button is pressed
                    print("Feedback button pressed");
              },
              child: Text('Give Feedback'),
            ),
                  ],
                )
                :SizedBox(),
          ],
      )
    );
  }
}
class CardCategoryTile extends StatelessWidget {
  final  imageUrl;
  final  categoryName;

   CardCategoryTile({this.imageUrl,this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       Get.find<NewsController>().fetchNewsData(country: getCategoryCode(categoryName));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: Image.network(
                imageUrl,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
               color: Colors.transparent
              ),
                child: Text(categoryName,
                style: const TextStyle(
                  color: Colors.black
                ),))

          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String? imageUrl;
  final String? url;
  final String? title;
  final String? description;
  const BlogTile({required this.imageUrl,required this.title,required this.description,this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(ArticleView(title: "Box News",url: url,));
      },
      child: Column(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              child:
              Image.network(imageUrl!,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) {
      return child;
      }
      return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: frame != null
      ? child // Display the image once it is loaded
        : const Center(
      child: CircularProgressIndicator(), // Loading spinner
      ),
      );
              },
              )),
          Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.transparent
              ),
              child: Text(title!,
                style: const TextStyle(
                    color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600
                ),)),
          const SizedBox(height: 10.0),
          Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.transparent
              ),
              child: Text(description!,
                style: const TextStyle(
                    color: Colors.grey,
                ),)),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class CustomRefreshIndicatorWidget extends StatelessWidget {
  final double offsetToArmed;
  final IndicatorController controller;
  final Function() onRefresh;
  final Color firstRingColor;
  final Color secondRingColor;
  final Color thirdRingColor;
  final double size;
  final Widget child;

  const CustomRefreshIndicatorWidget({
    required this.offsetToArmed,
    required this.controller,
    required this.onRefresh,
    required this.firstRingColor,
    required this.secondRingColor,
    required this.thirdRingColor,
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: offsetToArmed,
      controller: controller,
      onRefresh:() => onRefresh(),
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          child: child,
          builder: (BuildContext context, _) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!controller.isIdle)
                  Positioned(
                    top: 10,
                    child: Lottie.asset("assets/loading.json",),
                  ),
                Transform.translate(
                  offset: Offset(0, 20.0 * controller.value),
                  child: _,
                ),
              ],
            );
          },
        );
      },
      child: child,
    );
  }
}

String getCategoryCode(String country ){
  String temp;
  switch (country) {
    case "Business":
      return temp= "business";
    case "Politics":
      return temp="politics";
    case "Entertainment":
      return temp="entertainment";
    case "Music":
      return temp= "mus";
    case "Sports":
      return temp="sports";
    default:
      return temp ="business";
  }
}