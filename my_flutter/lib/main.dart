import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'secondFlutter.dart';

void main() => runApp(_widgetForRoute(window.defaultRouteName));
Widget _widgetForRoute(String url) {
  // route名称
  String route =
  url.indexOf('?') == -1 ? url : url.substring(0, url.indexOf('?'));
// 参数Json字符串
  String paramsJson =
  url.indexOf('?') == -1 ? '{}' : url.substring(url.indexOf('?') + 1);
  Map<String, dynamic> mapJson = json.decode(paramsJson);
  String message = mapJson["message"];
  //解析参数
  switch (route) {
    case 'route1':
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter页面'),
          ),
          body: ContentWidget(route: route,message: message,),
        )
      );
      default:
      return Center(
        child: Text('Unknown route: $route', style: TextStyle(color: Colors.red),textDirection: TextDirection.ltr,),
      );
  }
}

class ContentWidget extends StatefulWidget {
  ContentWidget({Key key, this.route, this.message}) : super (key : key);
  String route, message;
  _ContentWidgetState createState() => new _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget>{
  static const nativeChannel = const MethodChannel('com.example.flutter/native');
  static const flutterChannel = const MethodChannel('com.example.flutter/flutter');
  void onDataChange(val) {
    setState(() {
      widget.message = val;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<dynamic> handler(MethodCall call) async {
      switch(call.method){
        case 'onActivityResult':
          onDataChange(call.arguments['message']);
          print('1234'+call.arguments['message']);
          break;
        case 'backAction':
          if(Navigator.canPop(context)){
            Navigator.of(context).pop();
          }else {
            nativeChannel.invokeMethod('backAction');
          }
          break;
      }
    }
    flutterChannel.setMethodCallHandler(handler);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        children: <Widget>[
          Positioned(child:
          Text(widget.message,textAlign: TextAlign.center,),
          top: 100,
          left: 0,
          right: 0,
          height: 100,
          ),
          Positioned(child: RaisedButton(
            onPressed: (){
              returnLastNativePage(nativeChannel);
              },
              child: Text('打开上一个原生页面'),
          ),
          top: 200,
          left: 100,
          right: 100,
          height: 100,
          ),
          Positioned(
            top: 330,
            left: 100,
            right: 100,
            height: 100,
            child: RaisedButton(
              child: Text('打开下一个原生页面'),
              onPressed: (){
                openNextNativePage(nativeChannel);
              }
              ),
              ),
          Positioned(
            top: 460,
            left: 100,
            right: 100,
            height: 100,
            child: RaisedButton(
              child: Text('打开下一个Flutter页面'),
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => SecondFlutterWidget(),
                  ),
                  );
              }))
        ],
      ),
    );
  }
}

Future returnLastNativePage(MethodChannel channel) async {
   //参数
//  const channel = const MethodChannel('com.example.flutter/native');
//  static const flutterChannel = const MethodChannel('com.example.flutter/flutter');
  Map<String, dynamic> para = {'message':'嗨，本文案来自Flutter页面，回到第一个原生页面将看到我'};
  final String result = await channel.invokeMethod('backFirstNative',para);
  print('这是在flutter中打印的'+ result);
} 

Future openNextNativePage(MethodChannel channel) async{
    //参数
//  const channel = const MethodChannel('com.example.flutter/native');
  Map<String, dynamic> para = {'message':'嗨，本文案来自Flutter页面，打开第二个原生页面将看到我'};
  final String result = await channel.invokeMethod('openSecondNative',para);
  print('这是在flutter中打印的'+ result);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
