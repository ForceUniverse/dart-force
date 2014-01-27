part of dart_force_client_lib;

class ForceClient extends ForceBaseMessageSendReceiver with ClientSendable {
  Socket socket;
  
  ForceMessageDispatcher _messageDispatcher;
  
  String wsPath;
  
  var _profileInfo = {};
  
  ForceClient({String wsPath: "/ws", String url: null, int heartbeat: 200, bool usePolling: false}) {
    print("create a forceclient");
    _messageDispatcher = new ForceMessageDispatcher(this);
    this.wsPath = wsPath;
    if (url==null) {
      url = '${Uri.base.host}:${Uri.base.port}';
    }
    
    this.socket = new Socket('$url$wsPath', usePolling: usePolling, heartbeat: heartbeat);
  }
  
  void connect() {
   this.socket.connect();
   this.socket.onMessage.listen((e) {
     _messageDispatcher.onMessageDispatch(onInnerMessage(e.data));
   });
  }
  
  void on(String request, MessageReceiver vaderMessageController) {
    _messageDispatcher.register(request, vaderMessageController);
  }
  
  void generateId() {
    return new Uuid().v4();
  }
   
  Stream<ConnectEvent> get onConnected =>  this.socket.onConnecting;
  Stream<ConnectEvent> get onDisconnected =>  this.socket.onDisconnecting;
}