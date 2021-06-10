import 'dart:convert';
import 'networking_service.dart';

class CountriesService {
//
  static List<dynamic> _countries;

  static Future<List<dynamic>> getCountries() async {
    if (_countries == null) {
      final getCountries = await NetworkingService.getCountries();
      final data = json.decode(getCountries.body)['data'];
      if (data is List<dynamic>) {
        _countries = data;
        return _countries;
      } else {
        print('data runtimeType: ${data.runtimeType}');
        throw Exception('Error to fetch countries');
      }
    } else
      return _countries;
  }

//
}
