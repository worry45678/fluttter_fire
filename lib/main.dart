import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

Dio dio = new Dio();

void getHttp() async {
  try {
    Response response = await dio.get("http://api.devgame.top/scada/test/");
    print(response);
    final body = json.decode(response.toString());
    print(body['data']);
  } catch (e) {
    print(e);
  }
}


void main() {
  runApp(new MaterialApp(
    title: 'Navigation Basics',
    home: new FirstScreen(),
  ));
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('First Screen'),
        ),
        body: new ListView(
          children: <Widget>[
            new RaisedButton(
              child: new Text('检查列表'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SecondScreen()),
                );
              },
            ),
            new RaisedButton(
              child: new Text('扫码界面'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new ScanQr()),
                );
              },
            ),
            new RaisedButton(
                child: new Text('获取数据'), onPressed: getHttp),
          ],
        ));
  }

}

class Record {
  const Record({this.name, this.date, this.isCheck});
  final String name;
  final DateTime date;
  final bool isCheck;
}

final records = <Record>[
  new Record(name: '灭火器1', date: null, isCheck: true),
  new Record(name: '灭火器2', date: null, isCheck: true),
  new Record(name: '灭火器3', date: null, isCheck: true),
  new Record(name: '灭火器4', date: null, isCheck: false),
  new Record(name: '灭火器5', date: null, isCheck: false),
];

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({Record record})
      : record = record,
        super(key: new ObjectKey(record));

  final Record record;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return record.isCheck ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!record.isCheck) return null;

    return new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: _getColor(context),
        child: new Text(record.name[0]),
      ),
      title: new Text(record.name, style: _getTextStyle(context)),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  createState() => new SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          tooltip: 'Navigation menu',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: new Text(barcode),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      body: new ListView(
        children: records.map((Record record) {
          return new ShoppingListItem(
            record: record,
          );
        }).toList(),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: new Icon(Icons.camera),
        onPressed: scan,
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        return this.barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          return this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() {
          return this.barcode = 'Unknown error: $e';
        });
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}

class ScanQr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: SacnBody(),
    );
  }
}

class SacnBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyScanState();
  }
}

class _MyScanState extends State<SacnBody> {
  String barcode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('QR Code'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: RaisedButton(
                  color: Colors.orange,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text('START CAMERA SCAN')),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                barcode,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        return this.barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          return this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() {
          return this.barcode = 'Unknown error: $e';
        });
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
