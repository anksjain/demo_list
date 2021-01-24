import 'dart:async';
import 'package:demo_list/model/country.dart';
import 'package:demo_list/provider/db.dart';

class CountryBloc {
  //constructor
  CountryBloc() {
    getCountry();
  }
  final _countryController =StreamController<List<CountryDetail>>.broadcast();
  get countries => _countryController.stream;

  //avoid memoery leak
  dispose() {
    _countryController.close();
  }

  getCountry() async {
    _countryController.sink.add(await DBProvider.dbProvider.getAllFavouriteCountry());
  }
}