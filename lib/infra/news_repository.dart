import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:news_box/infra/i_new_repository.dart';
import 'package:news_box/modal/news_modal.dart';

class NewsService extends INewsRepository{
  final Dio _dio = Dio();

  // Define the base URL and API key
  final String _url = 'https://newsapi.org/v2/top-headlines';
  final String _apiKey = 'c4cab034529b4dda89d028703603fd91';

  NewsService();
  @override
  Future<Either<String,NewsModal>> fetchTopHeadlines({String country="us"}) async {
    try {
      // Making the GET request with the required parameters
      final response = await _dio.get(_url, queryParameters: {
        'country': "us",
        'category': country,
        'apiKey': _apiKey,
      });

      if (response.statusCode == 200) {
        NewsModal data;
        return right(NewsModal.fromJson(response.data));
      } else {
        return left("error");
      }
    } on DioError catch (e) {
      // Handling Dio errors, such as network issues or invalid requests
      if (e.response != null) {
        print('Dio error! Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
        return left("error");
      } else {
        print('Error sending request: ${e.message}');
        return left("error");
      }
    }
  }
}
