import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {

  Map _data = await getJson();
  List _features = _data['features'];
//  for(int i = 0; i < _data.length; i++) {
//
//  }
//  print("");

  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Quake App"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, int position) {

            if(position.isOdd)
              return new Divider();

            final index = position ~/ 2;

            var format = new DateFormat.yMMMd("en_US").add_jm();
            //
            var date = new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000, isUtc: true);
            var dateString = format.format(date);

            return new ListTile (

              title: new Text("$dateString",
                style: new TextStyle(fontSize: 14.9, color: Colors.orange, fontWeight: FontWeight.w500),
              ),

              subtitle: new Text("${_features[index]['properties']['place']}",
                style: new TextStyle(fontSize: 13.4, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)
              ),

              leading: new CircleAvatar(
                backgroundColor: Colors.green,
                child: new Text("${_features[index]['properties']['mag']}",
                  style: new TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  )
                ),
              ),

              onTap: () {
                _showTapMessage(context, "${_features[index]['properties']['title']}");
              }
            );

          }
        ),
      )
    )

  ));
}

void _showTapMessage(BuildContext context, String message) {
  var alert = new AlertDialog(
    title: new Text("Quakes"),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: new Text("OK"),
      )
    ]
  );
  showDialog(context: context, builder: (context) => alert);


}

Future<Map> getJson() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);

}

