import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;


class Klimatic extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return KlimaticState();
  }

}

class KlimaticState extends State<Klimatic>{

  String _cityEntered;
  Future goToNextScreen(BuildContext context ) async{
    Map results = await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext context){
        return ChangeCity();
      })
    );
    if(results != null && results.containsKey('enter')){
     // print(results['enter'].toString());
     // debugPrint("From First Screen " + results['enter'].toString());
      _cityEntered = results['enter'];
    }

  }
  void showStuff() async{
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Klimatic App"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => goToNextScreen(context)
          )
        ],
      ),
      
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/umbrella.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
          ),

          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text("${_cityEntered == null ? util.defaultCity : _cityEntered }", style: cityStyle(),),
          ),
          
          Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png"),
          ),

          updateTempWidget(_cityEntered)
          //Containing weather data
        //  Container(
           // alignment: Alignment.center,
          //  margin: EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
           // child: ,
          //)


        ],
      ),
    );
  }

  Future<Map> getWeather(String appId , String city ) async {
    String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=${util.appId}&units=metric";

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);


}
  Widget updateTempWidget(String city){
    return new FutureBuilder(
      future: getWeather(util.appId, city==null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        if(snapshot.hasData){
          Map content = snapshot.data;
          return Container(
            margin: EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(content['main']['temp'].toString()+ " C ",
                  style: TextStyle(
                    fontSize: 49.9,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: Colors.white
                  ),
                  ),
                  subtitle: ListTile(
                    title: Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()} C\n"
                          "Max: ${content['main']['temp_max'].toString()} C\n",
                      style: extraData(),


                    ),
                  ),
                )
              ],
            ),
          );
        }else{
          return Container();
        }
      
    });
  }
}

class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change City"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset("images/white_snow.png",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          ListView(
            children: <Widget>[

              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter City"
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),

              ListTile(
                title: FlatButton(
                  onPressed: (){
                    Navigator.pop(context, {
                      'enter': _cityFieldController.text
                    });
                  },
                  child: Text("Get Weather"),
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                ),
              )


            ],
          )

        ],
      ),
    );
  }
}


TextStyle cityStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle(){
  return TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );
}

TextStyle extraData(){
  return TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
      fontSize: 17.0
  );
}