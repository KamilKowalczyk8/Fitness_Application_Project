import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String token = '89b86aa5dc2da540ab5e89d3ab05f1d8cbfc7403';
  final String baseUrl = 'http://api.waqi.info/feed';

  Future<Map<String, dynamic>> fetchAqiData(String city) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/$city/?token=$token')
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMultipleCitiesAqiData(
      List<String> cities) async {
    List<Map<String, dynamic>> cityData = [];
    for (String city in cities) {
      var data = await fetchAqiData(city);
      cityData.add(data);
    }
    return cityData;
  }
}
