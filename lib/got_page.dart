import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Color mainColor = Colors.amber;
Color secColor = Colors.black;

class GotPage extends StatefulWidget {
  @override
  _GotPageState createState() => _GotPageState();
}

class _GotPageState extends State<GotPage> {
  var data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(Uri.parse(
        "https://api.tvmaze.com/singlesearch/shows?q=game-of-thrones&embed=episodes"));
    data = jsonDecode(res.body);
    setState(() {});
  }

  showGridWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: data['_embedded']['episodes'].length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemBuilder: (context, index) {
          var episode = data['_embedded']['episodes'][index];
          return Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  episode['image']['original'],
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      episode['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("S${episode['season']}E${episode['number']}"),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(16)),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  dataBody(BuildContext context) {
    var imgUrl = data['image']['original'];
    var body = Column(
      children: [
        Center(
          child: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
            radius: MediaQuery.of(context).size.width > 600 ? 150 : 70,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          data['name'],
          textScaleFactor: 2.0,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: showGridWidget(),
        )
      ],
    );
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('GOT'),
        centerTitle: true,
      ),
      body: data != null
          ? dataBody(context)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
