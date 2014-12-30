part of dart_force_client_lib;

class ForceClient extends Object with ClientSendable {
  Socket socket;
  
  String wsPath;
 
  ForceClientContext clientContext;
  
  var _profileInfo = {};

  ForceClient({String wsPath: "/ws", String url: null, String host: null, int port: null, int heartbeat: 500, bool usePolling: false}) {
    print("create a forceclient");
    
    clientContext = new ForceClientContext(this);  
    
    this.wsPath = wsPath;
    if (host==null) {
      host = '${Uri.base.host}';
    }
    if (port==null) {
      port = Uri.base.port;
    }
    if (url==null) {
      url = '$host:$port';
    }

    this.socket = new Socket('$url$wsPath', usePolling: usePolling, heartbeat: heartbeat);
    this.messenger = new BrowserMessenger(socket);
  }
  
  Stream<MessagePackage> get onMessage => clientContext.onMessage;
  
  ViewCollection register(String collection, CargoBase cargo, {Map params}) 
                          => clientContext.register(collection, cargo, params: params);
  
  void connect() {
   this.socket.connect();
   this.socket.onMessage.listen((e) {
     clientContext.protocolDispatchers.dispatch_raw(e.data);
   });
  }
  
  void on(String request, MessageReceiver forceMessageController) {
    clientContext.on(request, forceMessageController);
  }

  dynamic generateId() {
    var rng = new Random();
    return rng.nextInt(10000000);
  }

  Stream<ConnectEvent> get onConnected =>  this.socket.onConnecting;
  Stream<ConnectEvent> get onDisconnected =>  this.socket.onDisconnecting;
}