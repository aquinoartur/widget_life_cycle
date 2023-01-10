import 'dart:developer';

import 'package:flutter/material.dart';

import '../main.dart';

class RouteAwareWidget extends StatefulWidget {
  const RouteAwareWidget({super.key});

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, '/life-cycle'),
            child: const Text('GO TO NEXT PAGE'),
          ),
        ),
      );
}
