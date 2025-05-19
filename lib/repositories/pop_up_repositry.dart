import 'dart:convert'; 

import '../app_config.dart';
import 'api-request.dart';

Future<Map<String, dynamic>> fetchBannerpopupData() async {
  const String url = '${AppConfig.BASE_URL}/banners-popup';

  try {
    final response = await ApiRequest.get(url: url);

    // تأكد إن كانت الاستجابة ناجحة
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('Popup Banner Response: $data');
      return data;
    } else {
      print('Failed to load popup banner, status code: ${response.statusCode}');
      return {};
    }
  } catch (e) {
    print('Error fetching popup banner: $e');
    return {};
  }
}
