import 'package:demo_list/Helper/CountryHelper.dart';
import 'package:demo_list/Screen/offline.dart';
import 'package:demo_list/model/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:demo_list/provider/db.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>
    with SingleTickerProviderStateMixin {
  CountryHelper _countryHelper =
      new CountryHelper(); //Helper class to fetch Country data from API
  Countries _countries = new Countries(); // to store fetch data
  List<CountryDetail> dbList = new List<CountryDetail>();
  bool _offline = true; //check that Network is there or not
  List<bool> _isfavorited;
  TabController _tabController;

  getList() async {
    _countries = await _countryHelper.getCountry();
    // print(_countries.countryList[0].country);
    dbList = await DBProvider.dbProvider.getAllFavouriteCountry();
    _isfavorited =
        List<bool>.generate(_countries.countryList.length, (_) => false);
    favouriteList();
    setState(() {
      _offline = false;
    });
  }

  favouriteList() {
    for (int i = 0; i < _countries.countryList.length; i++) {
      for (int j = 0; j < dbList.length; j++) {
        if (_countries.countryList[i].countryCode == dbList[j].countryCode) {
          _isfavorited[i] = true;
          break;
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    _tabController = TabController(length: 2, vsync: this);
    getList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Country List"),
      ),
      body: TabBarView(
        children: <Widget>[_offline ? onFetching() : onFetched(), Offline()],
        controller: _tabController,
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color.fromRGBO(30, 30, 50, 1.0),
        child: TabBar(
          dragStartBehavior: DragStartBehavior.start,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.yellow,
          labelPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          labelColor: Colors.yellow,
          controller: _tabController,
          tabs: <Widget>[
            Icon(Icons.list),
            Icon(Icons.favorite),
          ],
        ),
      ),
    );
  }

  onFetched() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: _countries.countryList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Container(
              child: ListTile(
                title: Text(
                  _countries.countryList[index].country,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_countries.countryList[index].region),
                trailing: Text(_countries.countryList[index].countryCode,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic)),
                leading: IconButton(
                  onPressed: () => setState(() => {
                        _isfavorited[index] = !_isfavorited[index],
                        addFavourite(index, _isfavorited[index],
                            _countries.countryList[index].countryCode),
                      }),
                  icon: _isfavorited[index]
                      ? Icon(
                          Icons.star,
                          color: Colors.yellow,
                        )
                      : Icon(Icons.star_border),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  addFavourite(int index, bool check, String code) async {
    if (check)
      await DBProvider.dbProvider.addCountry(_countries.countryList[index]);
    else
      await DBProvider.dbProvider.deleteCountry(code);
  }

  onFetching() {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Text("Please check your network connectivity"),
      ),
    );
  }
}
