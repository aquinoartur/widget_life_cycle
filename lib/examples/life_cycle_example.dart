import 'package:flutter/material.dart';

import 'controller.dart';

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
  late final ScreenController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = ScreenController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.simulateRequest(length: 5);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  //* APP LIFE CYCLE
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        if ((controller.value.colors?.length ?? 0) > 0) {
          controller.simulateRequest(
            length: (controller.value.colors?.length ?? 1) - 1,
          );
        }
        break;
      case AppLifecycleState.resumed:
        controller.simulateRequest(
          length: (controller.value.colors?.length ?? 0) + 2,
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paleta de cores'),
      ),
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (value.colors?.isNotEmpty == true) {
            return ListView.separated(
              itemCount: value.colors!.length,
              itemBuilder: (context, index) {
                final color = value.colors![index];
                return Container(
                  height: 50,
                  color: color,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(
                color: Colors.white,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
