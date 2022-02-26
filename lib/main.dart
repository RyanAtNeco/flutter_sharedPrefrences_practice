import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shared preferences Practice',
      home: MyHomePage(title: 'Shared preferences practice'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _name = '';
  final textFieldController = TextEditingController();

  // Just for clearing TextField while editing it
  FocusNode textFieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadCounter();
    _loadName();
  }

  // Saveing the name
  void _saveName(inputName) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('name', inputName);
      _name = prefs.getString('name') ?? '';
    });
  }

  // Loadeing The name
  void _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('name') ?? '');
    });
  }

  String get name {
    if (_name.isEmpty) {
      return 'Hi, <tell me your name>';
    } else {
      return 'Hi, $_name';
    }
  }

  //Loading counter value on start
  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
  }

  //Incrementing counter after click
  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });

    // This part is for clearing the text
    textFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: textFieldController,
                onSubmitted: (value) {
                  _saveName(value);
                  FocusScope.of(context).unfocus();
                  textFieldController.clear();
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),

            // A text field that must have a hint when it is not focused
            // and no hint when it is focused
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: TextField(
            //     controller: textFieldController,
            //     onSubmitted: (value) {
            //       _saveName(value);
            //       FocusScope.of(context).unfocus();
            //       textFieldController.clear();
            //     },
            //     textAlign: TextAlign.center,
            //     decoration: InputDecoration(
            //       border: InputBorder.none,
            //       hintText: textFieldFocus.hasFocus ? '' : name,
            //       hintStyle: const TextStyle(
            //         color: Colors.blue,
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //       ),
            //       contentPadding: const EdgeInsets.all(10),
            //     ),
            //   ),
            // ),
            Text(
              name,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'You have pushed the button this many times till now:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
