import 'dart:developer';

import 'package:flutter/material.dart';

import '../main.dart';

class RouteAwareWidget extends StatefulWidget {
  final String parametro;

  const RouteAwareWidget({super.key, this.parametro = ''});

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
    log('initState foi executado');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('didChangeDependencies foi executado');
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    // Este método é chamado quando uma dependência do objeto State muda ou imediatamente após initState()
    //ou seja, quando o widget é construído.
    // Exemplos de uso:
    // Provider.of<>(context)
    // MediaQuery.of(context)
    // Theme.of(context)
  }

  @override
  void didUpdateWidget(covariant RouteAwareWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    /*
     Se o widget pai mudar e precisar reconstruir este widget (porque ele precisa fornecer dados diferentes, por exemplo de argumentos do construtor),
     mas está sendo reconstruído com o mesmo runtimeType, esse método é chamado.
     Isso ocorre porque o Flutter está reutilizando o estado, que é de longa duração.
     Nesse caso, você pode querer inicializar alguns dados novamente, como faria em initState.
     */
    // aqui, podemos executar alguma lógica os parâmetros que recebemos via construtor
    // por exemplo:
    if (oldWidget.parametro != widget.parametro) {
      log("os parâmetros mudaram");
      // oldWidget te traz a configuração widget antiga, antes do pai desse widget e o mesmo terem sido reconstruídos
      log(oldWidget.parametro);
      // widget te traz a configuração atual, com os valor atual dos parâmetros recebidos via construtor
      log(widget.parametro);
    }
    /*
    Um bom exemplo de uso seria para reiniciar animações
      @override
      void didUpdateWidget(Foo oldWidget) {
        super.didUpdateWidget(oldWidget);
        _controller.duration = widget.duration;
      }
Dentro didUpdateWidgetdo , a duração do controlador de animação (tempo restante para a animação) é substituída/atualizada pela Stateduração do Widget.
A duração do controlador é configurada a partir de uma propriedade no widget Foo; conforme isso muda, o método State.didUpdateWidget é usado para atualizar o controlador.
Isso significa que quando parametro é reconstruído com um novo duration , o controlador de animação é atualizado com esse valor, em vez de ficar preso com a duração definida em initState, o original widget.duration

Outro exemplo seria para assinaturas do tipo ChangeNotifier ou Streams:

Por exemplo, com StreamBuilder, uma primeira compilação pode ser semelhante a:

  StreamBuilder(
    stream: Stream.value(42),
    builder: ...
  )

  E então algo muda e StreamBuilderé reconstruído com

  StreamBuilder(
    stream: Stream.value(21 ),
    builder: ...
  )

  Nesse caso, streammudou. Portanto, StreamBuilderprecisa parar de ouvir o anterior Streame ouvir o novo.
  Isso seria feito através do seguinte didUpdateWidget:

  StreamSubscription<T> subscription;

  @override
  void didUpdateWidget(StreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stream != oldWidget.stream) {
      subscription?.cancel();
      subscription = widget.stream?.listen(...);
    }
  }

  A mesma lógica se aplica a ChangeNotifierqualquer outro objeto observável.
    */
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
     Quando State é removido da subárvore A e reinserido na subárvore B devido ao uso de a GlobalKey, apenas o deactivate() método do ciclo de vida é invocado, 
     dispose() NÃO é chamado (portanto, State é apenas desativado, mas não descartado neste caso). 
     Quando a State é permanentemente removido da árvore, deactivate() é chamado primeiro e depois dispose() é chamado depois.
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
