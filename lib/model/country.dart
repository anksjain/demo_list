class Countries{
  int totalCount;
  List<CountryDetail> countryList;
  Countries({this.totalCount,this.countryList});
  factory Countries.fromJson(Map<String,dynamic> json)
  {
    return Countries(totalCount: json["total"],countryList:paresCountry(json["data"]));
  }
  static List<CountryDetail> paresCountry(Map<String,dynamic> json)
  {
    List<CountryDetail> countryList= new List<CountryDetail>();
    json.forEach((key, value) {
      countryList.add(CountryDetail.fromJson(value, key.toString()));
    });
    return countryList;
  }
}

class CountryDetail
{
  String country;
  String region;
  String countryCode;
  CountryDetail({this.country,this.region,this.countryCode});
  factory CountryDetail.fromJson(Map<String,dynamic> json,String code){
    return CountryDetail(country: json["country"],region: json["region"],countryCode: code);
  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> map = {
      'country': country,
      'code': countryCode,
      'region':region
    };
    return map;
  }

  static CountryDetail fromMap(Map<String, dynamic> map) {

    return new CountryDetail(
        country: map['country'],
        countryCode: map['code'],
        region: map['region']
    );
  }
}