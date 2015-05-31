part of force.client;

class ForceClient extends BaseForceClient with ClientSendable {
  Socket socket;
  
  String wsPath;

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
    
    onConnected.listen((ConnectEvent) {
      this.messenger.online();
    });
  }
  
  void connect() {
   this.socket.connect();
   this.socket.onMessage.listen((e) {
     clientContext.protocolDispatchers.dispatch_raw(e.data);
   });
  }

  dynamic generateId() {
    var rng = new Random();
    return rng.nextInt(10000000);
  }

  Stream<ConnectEvent> get onConnected =>  this.socket.onConnecting;
  Stream<ConnectEvent> get onDisconnected =>  this.socket.onDisconnecting;
}