import 'package:flutter/material.dart';
import 'package:widget_life_cycle/examples/life_cycle_example.dart';

import 'examples/route_aware.dart';

// Register the RouteObserver as a navigation observer.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const RouteAwareWidget(),
        '/life-cycle': (BuildContext context) => const ScreenLifecyle(),
      },
    );
  }
}
