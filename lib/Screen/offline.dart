import 'package:demo_list/bloc/BlocCountry.dart';
import 'package:demo_list/model/country.dart';
import 'package:flutter/material.dart';
class Offline extends StatefulWidget {
  @override
  _OfflineState createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  final bloc=CountryBloc();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<List<CountryDetail>>(
          stream: bloc.countries,
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator(),);
                  if(snapshot.data.length==0)
              return Center(child: Text("Left Swipe to add Favourite from list"),);
            return  Container(
                color: Colors.white,
                child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context,int index){
              return  Card(
                elevation: 5,
                color: Colors.white,
                child: Container(
                  child: ListTile(
                    title: Text(snapshot.data[index].country,style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(snapshot.data[index].region),
                    trailing: Text(snapshot.data[index].countryCode,style: TextStyle(fontWeight: FontWeight.w500,color:Colors.blue)),
                  ),
                ),
              );
            },
            ));
          },
        )
      );
  }
}
