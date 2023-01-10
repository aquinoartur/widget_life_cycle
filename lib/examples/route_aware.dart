import 'dart:developer';

import 'package:flutter/material.dart';

class RouteAwareWidget extends StatefulWidget {
  const RouteAwareWidget({super.key});

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget>
    with RouteAware, WidgetsBindingObserver {
  // WIDGET LIFE CYCLE

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(fn) {
    log('Houve atualização de dados');
    super.setState(fn);
  }

  // ROUTE AWARE
  @override
  void didPush() {
    log('DID PUSH: esta tela está visível');
    // A rota foi enviada para o navegador e agora é a rota superior.
  }

  @override
  void didPushNext() {
    log('DID PUSH NEXT: uma outra rota foi chamada');
    //Chamado quando uma nova rota foi enviada e a rota atual não está mais visível.
    super.didPushNext();
  }

  @override
  void didPop() {
    log('DID POP: está tela foi retirada');
    //Chamado quando a rota atual foi retirada.
    super.didPop();
  }

  @override
  void didPopNext() {
    log('DID POP NEXT: esta tela voltou a estar visível');
    // Chamado quando a rota principal foi exibida e a rota atual é exibida.
  }

  int count = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/life-cycle'),
                child: const Text('GO TO NEXT PAGE'),
              ),
            ),
          ],
        ),
        floatingActionButton: IconButton(
          onPressed: () {
            setState(() {
              count++;
            });
            log(count.toString());
          },
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            backgroundColor: Colors.purple,
          ),
        ),
      );
}
