part of dart_force_client_lib;

class ForceClient extends ForceBaseMessageSendReceiver with ClientSendable {
  Socket socket;
  
  ForceMessageDispatcher _messageDispatcher;
  
  String wsPath;
  
  var _profileInfo = {};
  
  ForceClient({String wsPath: "/ws", String url: null, String host: null, String port: null, int heartbeat: 500, bool usePolling: false}) {
    print("create a forceclient");
    _messageDispatcher = new ForceMessageDispatcher(this);
    _messageDispatcher.cargoHolder= new CargoHolderClient(this); 
    this.wsPath = wsPath;
    if (host==null) {
      host = '${Uri.base.host}';
    }
    if (port==null) {
      port = '${Uri.base.port}';
    }
    if (url==null) {
      url = '$host:$port';
    }
    
    this.socket = new Socket('$url$wsPath', usePolling: usePolling, heartbeat: heartbeat);
    
    this.messenger = new BrowserMessenger(socket);
  }
  
  void register(String collection, CargoBase cargo) {
    this.subscribe(collection);
    _messageDispatcher.cargoHolder.publish(collection, cargo);
  }
  
  void connect() {
   this.socket.connect();
   this.socket.onMessage.listen((e) {
     _messageDispatcher.onMessagesDispatch(onInnerMessage(e.data));
   });
  }
  
  void on(String request, MessageReceiver vaderMessageController) {
    _messageDispatcher.register(request, vaderMessageController);
  }
  
  dynamic generateId() {
    var rng = new Random();
    return rng.nextInt(10000000);
  }
   
  Stream<ConnectEvent> get onConnected =>  this.socket.onConnecting;
  Stream<ConnectEvent> get onDisconnected =>  this.socket.onDisconnecting;
}