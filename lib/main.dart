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
    final records3 = body['data'].map((rec) {
      return new Record(
          date: rec['date'], name: rec['name'], isCheck: rec['isCheck']);
    }).toList();
    print(records3);
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
          title: new Text('灭火器、消火栓点检系统'),
        ),
        body: new ListView(
          children: <Widget>[
            new RaisedButton(
              child: new Text('检查列表'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new CheckList()),
                );
              },
            ),
          ],
        ));
  }
}

class Record {
  const Record({this.name, this.date, this.isCheck});
  final String name;
  final String date;
  final bool isCheck;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _phoneState, _pwdState = false;
  String _checkStr;
  TextEditingController _phonecontroller = new TextEditingController();
  TextEditingController _pwdcontroller = new TextEditingController();

  void _checkPhone() {
    if (_phonecontroller.text.isNotEmpty &&
        _phonecontroller.text.trim().length == 11) {
      _phoneState = true;
    } else {
      _phoneState = false;
    }
  }

  void _checkPwd() {
    if (_pwdcontroller.text.isNotEmpty &&
        _pwdcontroller.text.trim().length >= 6 &&
        _pwdcontroller.text.trim().length <= 10) {
      _pwdState = true;
    } else {
      _pwdState = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '轻签到',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('极速登录'),
        ),
        body: new ListView(
          children: <Widget>[
            new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.all(30.0),
                    child: new Image.asset(
                      'images/ic_launcher.png',
                      scale: 1.2,
                    )),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
                  child: new Stack(
                    alignment: new Alignment(1.0, 1.0),
                    //statck
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Padding(
                              padding:
                                  new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                              child: new Image.asset(
                                'images/icon_username.png',
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                            new Expanded(
                              child: new TextField(
                                controller: _phonecontroller,
                                keyboardType: TextInputType.phone,
                                decoration: new InputDecoration(
                                  hintText: '请输入用户名',
                                ),
                              ),
                            ),
                          ]),
                      new IconButton(
                        icon: new Icon(Icons.clear, color: Colors.black45),
                        onPressed: () {
                          _phonecontroller.clear();
                        },
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 40.0),
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Padding(
                          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                          child: new Image.asset(
                            'images/icon_password.png',
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                        new Expanded(
                          child: new TextField(
                            controller: _pwdcontroller,
                            decoration: new InputDecoration(
                              hintText: '请输入密码',
                              suffixIcon: new IconButton(
                                icon: new Icon(Icons.clear,
                                    color: Colors.black45),
                                onPressed: () {
                                  _pwdcontroller.clear();
                                },
                              ),
                            ),
                            obscureText: true,
                          ),
                        ),
                      ]),
                ),
                new Container(
                  width: 340.0,
                  child: new Card(
                    color: Colors.blue,
                    elevation: 16.0,
                    child: new FlatButton(
                      child: new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Text(
                          '极速登录',
                          style: new TextStyle(
                              color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                      onPressed: () {
                        _checkPhone();
                        _checkPwd();
                        if (_phoneState && _pwdState) {
                          _checkStr = '页面跳转下期见咯！';
                        } else {
                          if (!_phoneState) {
                            _checkStr = '请输入11位手机号！';
                          } else if (!_pwdState) {
                            _checkStr = '请输入6-10位密码！';
                          }
                        }
                        print(_checkStr);
                        showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          child: new AlertDialog(
                            title: new Text(
                              '温馨提示',
                              style: new TextStyle(
                                color: Colors.black54,
                                fontSize: 18.0,
                              ),
                            ),
                            content: new Text(_checkStr),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Text('确定')),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
      trailing: new Text(record.date, style: _getTextStyle(context)),
    );
  }
}

class CheckList extends StatefulWidget {
  @override
  createState() => new CheckListState();
}

class CheckListState extends State<CheckList> {
  String barcode = "";
  var records = [];

  Future getCheckList() async {
    try {
      Response response = await dio.get("http://39.104.64.142:9999/log");
      final body = json.decode(response.toString());
      final records3 = body['data'].map((rec) {
        return new Record(
            date: rec['date'], name: rec['name'], isCheck: rec['isCheck']);
      }).toList();
      setState(() {
        this.records = records3;
      });
    } catch (e) {
      print(e);
    }
  }

  Future postCheck(int id) async {
    try {
      Response response =
          await dio.post("http://39.104.64.142:9999/check", data: {"id": id});
      final body = json.decode(response.toString());
      print(body);
      getCheckList();
    } catch (e) {
      print(e);
    }
  }

  // 实例化时运行的方法
  @override
  void initState() {
    super.initState();
    getCheckList();
  }

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
        title: new Text('今日点检记录'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            tooltip: 'Search',
            onPressed: getCheckList,
          ),
        ],
      ),
      body: new ListView(
        children: records.map((record) {
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
      postCheck(int.parse(barcode));
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
