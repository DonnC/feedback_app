import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter IFTTT Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller;
  int _counter = 0;
  bool loading = false;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> sendFeedbackToEmail() async {
    setState(() {
      loading = true;
    });

    final _dio = Dio();
    final _baseUrl = 'https://maker.ifttt.com/trigger/';

    // TODO: Replace with your own webhook key
    final _webKey = '';

    // grab IFTTT event to trigger
    // TODO: replace with your own event name
    final String eventName = '';

    final String url = _baseUrl + eventName + '/with/key/' + _webKey;

    var feedback = controller.text;

    // construct payload with feedback passed as value1
    var payload = {
      'value1': feedback,
    };

    var result = await _dio.post(url, data: payload);

    print(result);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Please input your feedback below',
            ),
            SizedBox(height: 30),
            TextField(
              controller: controller,
              maxLines: 5,
              maxLength: 1024,
              maxLengthEnforced: true,
            ),
            SizedBox(height: 30),
            loading
                ? Center(child: CircularProgressIndicator())
                : FlatButton(
                    color: Colors.blue,
                    onPressed: () async => await sendFeedbackToEmail(),
                    child: Text('SUBMIT'),
                  ),
          ],
        ),
      ),
    );
  }
}
