import 'package:flutter/material.dart';
import 'package:share/share.dart';


class GifPage extends StatelessWidget {

  final Map _gifData;

GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( _gifData["title"], style: TextStyle(color: Color(0xFFCAC7C7)),), 
        backgroundColor: Color(0xFF121212),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share), 
            onPressed: (){
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            }
          )
        ],
      ),
      body: Center(
        
        child: Image.network(_gifData["images"]["fixed_height"]["url"])
      ),
      backgroundColor:  Color(0xFF121212),
    );
  }
}