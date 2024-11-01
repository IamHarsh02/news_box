import 'package:get/get.dart';
import 'package:news_box/infra/news_repository.dart';
import 'package:news_box/modal/news_modal.dart';

class NewsController extends GetxController {
  NewsService repository;
  NewsController(this.repository);
  bool isLoading=false;
  bool isError =false;
  NewsModal dataModal=NewsModal();
  @override
  void onInit() {
    fetchNewsData();
    super.onInit();
  }

  @override
  void onClose() {

  }

  fetchNewsData({String country="business"})async{
    isLoading=true;
    update();
    var result= await repository.fetchTopHeadlines(country:country);
    result.fold((l)  {
      isError=true;
      print(l);
    }, (r)  {
      isLoading=false;
      dataModal=r;
      update();
    });
  }
}