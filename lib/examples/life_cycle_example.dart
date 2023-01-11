import 'package:flutter/material.dart';

class ScreenLifecyle extends StatefulWidget {
  const ScreenLifecyle({super.key});

  //createState(): When the Framework is instructed to build a StatefulWidget, it immediately calls createState()
  @override
  State<StatefulWidget> createState() {
    return ScreenLifecyleState();
  }
}

class ScreenLifecyleState extends State<ScreenLifecyle>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
