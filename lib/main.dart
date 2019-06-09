import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

Dio dio = new Dio();

const baseUrl = "http://39.104.64.142:9999/";
// const baseUrl = "http://192.168.21.183:9999/";

// 可删除部分
void getHttp() async {
  try {
    String username = 'admin';
    String password = '123456';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    dio
        .post(baseUrl + "login",
            options: new Options(
              headers: {"Authorization": basicAuth},
            ))
        .then((response) {
      print(response.data);
    });
  } catch (e) {
    print(e);
  }
}

void main() {
  runApp(new MaterialApp(
    title: 'Navigation Basics',
    home: new MyHomePage(),
  ));
}

// 测试用界面
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void getLogin() async {
      try {
        String username = 'admin';
        String password = '123456';
        String basicAuth =
            'Basic ' + base64Encode(utf8.encode('$username:$password'));
        print(basicAuth);

        dio
            .post(baseUrl + "login",
                options: new Options(
                  headers: {"Authorization": basicAuth},
                ))
            .then((response) {
          if (response.data['code'] == 20000) {
            Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(builder: (context) => new CheckList()),
              (route) => route == null,
            );
          }
        });
      } catch (e) {
        print(e);
      }
    }

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
            new RaisedButton(child: new Text('测试登录'), onPressed: getLogin),
            new RaisedButton(
              child: new Text('登录界面'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new MyHomePage()),
                );
              },
            ),
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _phonecontroller = new TextEditingController();
  TextEditingController _pwdcontroller = new TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    void getLogin() async {
      try {
        String basicAuth = 'Basic ' +
            base64Encode(
                utf8.encode('${_phonecontroller.text}:${_pwdcontroller.text}'));
        dio
            .post(baseUrl + "login",
                options: new Options(
                  headers: {"Authorization": basicAuth},
                ))
            .then((response) {
          // print(response.data);
          if (response.data['code'] == 20000) {
            dio.interceptors
                .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
              options.headers["Authorization"] =
                  "Bearer " + response.data['token'];
              // 在请求被发送之前做一些事情
              return options; //continue
              // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
              // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
              //
              // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
              // 这样请求将被中止并触发异常，上层catchError会被调用。
            }, onResponse: (Response response) {
              // 在返回响应数据之前做一些预处理
              return response; // continue
            }, onError: (DioError e) {
              // 当请求失败时做一些预处理
              return e; //continue
            }));
            Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(builder: (context) => new CheckList()),
              (route) => route == null,
            );
          }
        });
      } on DioError catch (e) {
        print('*********************${e.message}');
        setState(() {
          _error = e.message;
        });
      }
    }

    return new MaterialApp(
      title: '点检系统',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('灭火器、消火栓点检系统登录'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              tooltip: 'Search',
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FirstScreen()),
                );
              },
            ),
          ],
        ),
        body: new ListView(
          children: <Widget>[
            new Text(_error),
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
                                keyboardType: TextInputType.text,
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
                            '登录',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                        onPressed: getLogin),
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

class Record {
  const Record({this.name, this.date, this.isCheck, this.result});
  final String name;
  final String date;
  final String result;
  final bool isCheck;
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
      subtitle: new Text(record.date),
      trailing: new Text(record.result),
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
      Response response = await dio.get(baseUrl + "log");
      final body = json.decode(response.toString());
      final records3 = body['data'].map((rec) {
        return new Record(
            date: rec['check_date'],
            name: rec['name'],
            isCheck: rec['isCheck'],
            result: rec['result']);
      }).toList();
      setState(() {
        this.records = records3;
      });
    } catch (e) {
      print(e);
    }
  }

  Future postCheck(String code) async {
    try {
      Response response =
          await dio.post(baseUrl + "check", data: {"code": code});
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
        //leading: new IconButton(icon: new Icon(Icons.arrow_back),tooltip: 'Navigation menu', onPressed: () {Navigator.pop(context);},),
        title: new Text('当日检查情况'),
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
      /*setState(() {
        return this.barcode = barcode;
      });*/
      if (barcode.length == 6) {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new CheckForm(code: barcode)),
        );
      } else {
        print('无效code');
      }
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

class CheckForm extends StatefulWidget {
  CheckForm({Key key, this.code}) : super(key: key);
  final String code;

  @override
  createState() => new CheckFormState();
}

class CheckFormState extends State<CheckForm> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  int _result;

  String _content;

  String _labelText = '检查结果';

  void _forLabelText() {
    Map list = {1: '正常', 2: '过期', 3: '损坏'};
    setState(() {
      _labelText = list[_result];
    });
  }

  void _forSubmitted() {
    var _form = _formKey.currentState;

    if (_form.validate()) {
      _form.save();
      print(_result);
      print(_content);
      print(_labelText);
      Map params = {
        'result': _result,
        'content': _content,
        'code': widget.code
      };
      postCheck(params);
    }
  }

  Future postCheck(Map params) async {
    try {
      Response response =
          await dio.post(baseUrl + "check", data: params).then((response) {
        Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => new CheckList()),
          (route) => route == null,
        );
        print(response.data);
      });
      final body = json.decode(response.toString());
      print(body);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: '检查情况填报',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('检查情况'),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: _forSubmitted,
          child: new Text('提交'),
        ),
        body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new Form(
            key: _formKey,
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text('设备代码'),
                  trailing: new Text(widget.code),
                ),
                new DropdownButtonFormField(
                    decoration: new InputDecoration(
                        prefixText: 'prefix', labelText: _labelText),
                    onChanged: (val) {
                      _result = val;
                      _forLabelText();
                    },
                    items: [
                      new DropdownMenuItem(child: new Text('正常'), value: 1),
                      new DropdownMenuItem(child: new Text('过期'), value: 2),
                      new DropdownMenuItem(child: new Text('损坏'), value: 3)
                    ]),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: '情况描述',
                  ),
                  obscureText: false,
                  validator: (val) {
                    return val.length < 0 ? "字数太少" : null;
                  },
                  onSaved: (val) {
                    _content = val;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
