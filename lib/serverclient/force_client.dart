part of dart_force_server_lib;

class ForceClient extends Object with ClientSendable {
  ForceSocket socket;
  
  ForceClientContext clientContext;
  
  String host;
  int port;
  String url;
  
  ForceClient({this.host: '127.0.0.1', this.port: 4041, this.url: null}) {
    clientContext = new ForceClientContext(this);  
    
    this.messenger = new ServerMessenger(socket);
  }
  
  Stream<MessagePackage> get onMessage => clientContext.onMessage;
    
  ViewCollection register(String collection, CargoBase cargo, {Map params}) 
                          => clientContext.register(collection, cargo, params: params);
    
  
  Future connect() {
    Completer completer = new Completer();
    Socket.connect(this.host, this.port).then((Socket serverSocket) {
     this.socket = new ServerSocketWrapper(serverSocket);
     this.messenger = new ServerMessenger(socket);
     
     socket.onMessage.listen((e) {
       clientContext.protocolDispatchers.dispatch_raw(e.data);
     });
     
     if (!completer.isCompleted) completer.complete();
   });
   return completer.future;
  }
  
  void on(String request, MessageReceiver forceMessageController) {
      clientContext.on(request, forceMessageController);
  }
  
}