import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:news_box/application/news_controller.dart';
import 'package:news_box/infra/i_new_repository.dart';
import 'package:news_box/infra/news_repository.dart';

class ConfigBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    // Get.put(NewsController(Get.find()));
    Get.put(NewsController(NewsService() ));
  }

}