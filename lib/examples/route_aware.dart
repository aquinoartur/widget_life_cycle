import 'dart:developer';

import 'package:flutter/material.dart';

import '../main.dart';

class RouteAwareWidget extends StatefulWidget {
  const RouteAwareWidget({super.key});

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget>
    with RouteAware, WidgetsBindingObserver {
  //* WIDGET LIFE CYCLE
  @override
  void initState() {
    /*
     Mounted = true: quando createState cria sua classe de estado, um buildContext é atribuído a esse estado.
     BuildContext é, excessivamente simplificado, o local na árvore de widgets em que este widget é colocado.
     Cada widget têm uma propriedade bool this.mounted. Ele se torna verdadeiro quando o buildContext é atribuído.
     É um erro chamar setState quando um widget é desmontado.
     Mounted = false: o objeto de estado nunca pode ser remontado e um erro é gerado quando setState é chamado.
  */

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    // Este método é chamado imediatamente após initState na primeira vez que
    //o widget é construído.
  }

  @override
  void didUpdateWidget(covariant RouteAwareWidget oldWidget) {
    /*
     Se o widget pai mudar e precisar reconstruir este widget (porque ele precisa fornecer dados diferentes),
     mas está sendo reconstruído com o mesmo runtimeType, esse método é chamado.
     Isso ocorre porque o Flutter está reutilizando o estado, que é de longa duração.
     Nesse caso, você pode querer inicializar alguns dados novamente, como faria em initState.
     */

    super.didUpdateWidget(oldWidget);
  }

  @override
  void setState(fn) {
    log('Houve atualização de dados');
    // Chamado quando o método setState é executado

    super.setState(fn);
  }

  @override
  void deactivate() {
    /*
     Deactivate é chamado quando State é removido da árvore,
     mas pode ser reinserido antes que a alteração do quadro atual seja concluída.
     Esse método existe basicamente porque os objetos State podem ser movidos de um ponto a outro em uma árvore.
     */
    super.deactivate();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    /*
     Dispose é chamado quando o objeto State é removido, o que é permanente.
     Este método é onde você deve cancelar a assinatura e cancelar todas as animações, streams, etc.
     */
    // routeObserver.unsubscribe(this);
    super.dispose();
  }

  //* APP LIFE CYCLE
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        log('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        log('appLifeCycleState resumed');
        // Aqui pode-se fazer um refresh de dados etc
        break;
      case AppLifecycleState.paused:
        log('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        log('appLifeCycleState detached');
        break;
      default:
        break;
    }
  }

  //* ROUTE AWARE
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
          onPressed: () {},
          icon: const Icon(Icons.refresh),
          style: IconButton.styleFrom(
            backgroundColor: Colors.purple,
          ),
        ),
      );
}
