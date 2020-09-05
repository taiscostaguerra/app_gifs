import 'dart:convert';

import 'dart:async';
import 'package:app_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  TextEditingController _searchController = new TextEditingController();

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == "" || _search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=ZLbE5RCSy9Ebz3Ka0UStCWCTfEs5Q4L0&limit=35&rating=g");
    } else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=ZLbE5RCSy9Ebz3Ka0UStCWCTfEs5Q4L0&q=$_search&limit=29&offset=$_offset&rating=g&lang=en");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Color(0xFF121212),
            title: Image.asset(
              "assets/logo.png",
              scale: 5.0,
            ),
            centerTitle: true,
            toolbarHeight: 100.0,
            elevation: 0.0,
          ),
          preferredSize: Size.fromHeight(100.0)),
      backgroundColor: Color(0xFF121212),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
          child: TextField(
            maxLines: 1,
            cursorColor: Color(0xFF6F6B6B),
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF3FDB90),
              ),
              hintText: "Search GIPHY",
              hintStyle: TextStyle(
                color: Color(0xFF6F6B6B),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                borderSide: BorderSide(
                  width: 0.0,
                  color: Color(0xFF121212),
                  style: BorderStyle.none,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                borderSide: BorderSide(
                  width: 0.0,
                  color: Color(0xFF121212),
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: EdgeInsets.all(8.0),
              fillColor: Color(0xFF333232),
              filled: true,
            ),
            style: TextStyle(
              color: Color(0xFFCAC7C7),
            ),
            onChanged: (text) {
              setState(() {
                _search = text;
                _offset = 0;
              });
            },
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: RefreshProgressIndicator(
                        backgroundColor: Color(0xFF333232),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF3FDB90)),
                        strokeWidth: 2.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                      
                }
              }),
        ),
        
      ]),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data["data"].length == 0 ||
        snapshot.data["data"].length == null) {
      return SingleChildScrollView(
          child: Column(children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
            child: Image.network(
              "https://media1.giphy.com/media/2rtQMJvhzOnRe/giphy.gif?cid=ecf05e479rhjt6b7vaal79917sx69p6zugqkbfn2qsdfqysc&rid=giphy.gif",
              width: 200.0,
            ),
          ),
        ),
        Container(
            child: Padding(
          padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
          child: Text(
            "No results for \"${_search}\", sorry :(",
            style: TextStyle(color: Color(0xFF848484)),
          ),
        )),
        
      ]));
    } else
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, ),
          itemCount: snapshot.data["data"].length + 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if(index == snapshot.data["data"].length) {
                return GestureDetector(
                  child: Container(
                    height: 20.0,
                    width: 10.0,
                    color: Color(0xFF333232),
                    child: Icon(
                      Icons.add,
                      color: Color(0xFF3FDB90),
                    )
                  ),
                  onTap: (){
                    // ta dando set state em tudo, tem q ajeitar
                    setState(() {
                      _offset += 19;
                    });
                  },
                );
            } else if (index < snapshot.data["data"].length) {
               return GestureDetector(
              child: FadeInImage.memoryNetwork(
                height: 300.0,
                fit: BoxFit.cover,
                placeholder: kTransparentImage, 
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"]),
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
                  );
              },
              onLongPress:  (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
            );
            }
            
          });
  }
}
