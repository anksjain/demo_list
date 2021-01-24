import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:demo_list/model/country.dart';
class CountryHelper
{
  // Countries countryData= new Countries();
  Future<Countries> getCountry() async{
    String URL="https://api.first.org/data/v1/countries";
    try {
      var response = await http.get(URL);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
      return Countries.fromJson(jsonBody);
      }
      else {
        throw("Error in API");
      }
    }catch(e)
    {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}