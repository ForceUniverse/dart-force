part of dart_force_server_lib;

class ForceServer extends ForceBaseMessageSendReceiver 
                                  with Serveable, Sendable { 
  
  final Logger log = new Logger('VaderServer');

  var uuid = new Uuid();
  BasicServer basicServer;
  ForceMessageDispatcher messageDispatcher;
  
  ForceServer({wsPath: "/ws", port: 8080, buildPath: '../build', startPage: "index.html" }) {
    basicServer = new BasicServer(wsPath, port: port, buildPath: buildPath);
    basicServer.startPage = startPage;
    webSockets = new Map<String, WebSocket>();
    messageDispatcher = new ForceMessageDispatcher(this);
  }
  
  Future start() {
    return basicServer.start(handleWs);
  }
  
  void register(Object obj) {
    InstanceMirror myClassInstanceMirror = reflect(obj);
    ClassMirror MyClassMirror = myClassInstanceMirror.type;
   
    Iterable<DeclarationMirror> decls =
        MyClassMirror.declarations.values.where(
            (dm) => dm is MethodMirror && dm.isRegularMethod);
    decls.forEach((MethodMirror mm) {
      if (mm.metadata.isNotEmpty) {
        var request = mm.metadata.first.reflectee;
        log.info("check is receiver -> $request");
        if (request is Receiver) {
          log.info("just a simple receiver method on -> $request");
          String name = (MirrorSystem.getName(mm.simpleName));
          Symbol memberName = mm.simpleName;
          
          on(request.path, (e, sendable) {
            log.info("execute this please!");
            InstanceMirror res = myClassInstanceMirror.invoke(memberName, [e, sendable]);
          }); 
        }
      }
    });
  }
  
  void handleWs(WebSocket webSocket) {
    String id = uuid.v4();
    log.info("register id $id");
    
    this.webSockets[id] = webSocket;
    webSocket.listen((data) {
      messageDispatcher.onMessageDispatch(onInnerMessage(data, wsId: id));
    });
    
    checkConnections();
  }
    
  void on(String request, MessageReceiver vaderMessageController) {
    messageDispatcher.register(request, vaderMessageController);
  }
  
  void checkConnections() {
    List<String> removeWs = new List<String>();
    this.webSockets.forEach((String key, WebSocket ws) {
      if (ws.readyState == WebSocket.CLOSED) {
        removeWs.add(key);
      }
    });
    
    removeWsConnections(removeWs);
  }
  
  void removeWsConnections(List<String> removeWs) {
    printAmountOfConnections();
    
    for (String wsId in removeWs) {
      this.webSockets.remove(wsId);
    } 
  }
  
}