import 'package:dartz/dartz.dart';
import 'package:news_box/modal/news_modal.dart';

abstract class INewsRepository {
  Future<Either<String,NewsModal>> fetchTopHeadlines({String country});

}