# STUDY: WIDGET AND APP LIFECYCLE (+ROUTE AWARE MIXIN)

A study of widget and application lifecycle states and methods.

Bonus: Study on complementary navigation methods using the Route Aware mixin


### **RESUMO GERAL**

1. **`createState()`:** quando o Framework é instruído a construir um StatefulWidget, ele chama imediatamente`createState()`
2. **`mounted`é verdadeiro:** Quando `createState`cria sua classe de estado, um `buildContext`é atribuído a esse estado. `buildContext`é, excessivamente simplificado, o local na árvore de widgets em que este widget é colocado. Todos os widgets têm uma `bool this.mounted`propriedade. Ele se torna verdadeiro quando o `buildContext`é atribuído. É um erro chamar `setState`quando um widget é desmontado.
3. **`initState()`:** Este é o primeiro método chamado quando o widget é criado (após o construtor da classe, é claro.) `initState`é chamado uma vez e apenas uma vez. Deve chamar `super.initState()`.
4. **`didChangeDependencies()`:** Este método é chamado imediatamente após `initState`a primeira vez que o widget é construído.
5. **`build()`:** Este método é chamado frequentemente. É obrigatório e deve retornar um Widget.
6. **`didUpdateWidget(Widget oldWidget)`:** Se o widget pai mudar e precisar reconstruir este widget (porque ele precisa fornecer dados diferentes), mas está sendo reconstruído com o mesmo `runtimeType`, esse método será chamado. Isso ocorre porque o Flutter está reutilizando o estado, que é de longa duração. Nesse caso, você pode querer inicializar alguns dados novamente, como faria em `initState`.
7. **`setState()`:** esse método é chamado frequentemente do próprio framework e do desenvolvedor. É usado para notificar a estrutura de que os dados foram alterados
8. **`deactivate()`:** Deactivate é chamado quando State é removido da árvore, mas pode ser reinserido antes que a mudança de quadro atual seja concluída. Esse método existe basicamente porque os objetos State podem ser movidos de um ponto a outro em uma árvore.
9. **`dispose()`:** `dispose()` é chamado quando o objeto State é removido, o que é permanente. Este método é onde você deve cancelar a assinatura e cancelar todas as animações, streams, etc.
10. **`mounted`é falso:** o objeto de estado nunca pode ser remontado e um erro será gerado se `setState`for chamado.

![Example](https://i.stack.imgur.com/94idE.png)

**Constructor**

Esta função não faz parte do ciclo de vida, pois desta vez o State da propriedade do widget está vazio, caso queira acessar as propriedades do widget no construtor não irá funcionar. Mas o construtor deve estar na primeira chamada.

### **AppLifecycleState**

- inativo - O aplicativo está em um estado inativo e não está recebendo entrada do usuário. **somente iOS**
- pausado - O aplicativo não está visível para o usuário no momento, não está respondendo à entrada do usuário e está sendo executado em segundo plano.
- retomado - O aplicativo está visível e respondendo à entrada do usuário.
- detached - O aplicativo será suspenso momentaneamente. **somente Android**

### RESUMED

O aplicativo está visível e respondendo à entrada do usuário.

### INACTIVE

O aplicativo está em um estado inativo e não está recebendo entrada do usuário.
No iOS, esse estado corresponde a um aplicativo ou exibição de host do Flutter em execução
no estado inativo de primeiro plano. Os aplicativos passam para esse estado quando em
uma chamada telefônica, respondendo a uma solicitação TouchID, ao entrar no aplicativo
switcher ou o centro de controle, ou quando o UIViewController hospedando o
O aplicativo Flutter está em transição.

No Android, isso corresponde a um aplicativo ou exibição de host do Flutter em execução
no estado inativo de primeiro plano. Os aplicativos passam para esse estado quando
outra atividade está focada, como um aplicativo de tela dividida, um telefonema,
um aplicativo picture-in-picture, uma caixa de diálogo do sistema ou outra janela.
Os aplicativos nesse estado devem assumir que podem ser [pausados] a qualquer momento.

### PAUSED

O aplicativo não está visível para o usuário no momento, não respondendo a
entrada do usuário e rodando em segundo plano.
Quando o aplicativo estiver nesse estado, o mecanismo não chamará o
[PlatformDispatcher.onBeginFrame] e [PlatformDispatcher.onDrawFrame]
retornos de chamada.

### DETACHED

O aplicativo ainda está hospedado em um mecanismo flutuante, mas está separado de
qualquer exibição de host.
Quando o aplicativo está nesse estado, o motor está funcionando sem
uma vista. Ele pode estar anexando uma visualização quando o mecanismo
foi inicializado pela primeira vez ou após a exibição ser destruída devido a um navegador
pop.

### Route Aware Mixin

```dart
abstract class RouteAware {
  /// Called when the top route has been popped off, and the current route
  /// shows up.
  void didPopNext() { }

  /// Called when the current route has been pushed.
  void didPush() { }

  /// Called when the current route has been popped off.
  void didPop() { }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  void didPushNext() { }
}
```

```dart
class RouteAwareWidget extends StatefulWidget {
  const RouteAwareWidget({super.key});

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {

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
            onPressed: () {
              Navigator.pushNamed(context, '/life-cycle');
            },
            child: const Text('navigate'),
          ),
        ),
      );
}
```

### LINKS ÚTEIS

[Explore Widget Lifecycle In Flutter](https://medium.flutterdevs.com/explore-widget-lifecycle-in-flutter-e36031c697d0)

[flutter/lifecycle.dart at master · flutter/flutter](https://github.com/flutter/flutter/blob/master/examples/layers/services/lifecycle.dart)

[Stateful Widget Lifecycle](https://www.bookstack.cn/read/flutterbyexample/aebe8dda4df3319f.md)

[How to check when my widget screen comes to visibility in flutter like onResume in Android](https://stackoverflow.com/questions/57856561/how-to-check-when-my-widget-screen-comes-to-visibility-in-flutter-like-onresume/58504433#58504433)

[Life cycle in flutter](https://stackoverflow.com/questions/41479255/life-cycle-in-flutter)
