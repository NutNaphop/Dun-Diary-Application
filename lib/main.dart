import 'package:dun_diary_app/shared/utils/dimension.dart';
import 'package:dun_diary_app/shared/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: CustomText(text: "Dun Diary" , fontSize: 16),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeadingText(text: "This is Dun Diary App"),
            SubHeadingText(text: "Welcome to the app!"),
            CustomText(text: "สวัสดีครับ นี่คือแอป Dun Diary", fontSize: Dimension.fontSizeMedium, fontWeight: Dimension.fontWeightRegular),
            CustomText(text: 'You have pushed the button this many times:', fontSize: Dimension.fontSizeMedium, fontWeight: Dimension.fontWeightRegular),
            CustomText(text: '$_counter',),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
