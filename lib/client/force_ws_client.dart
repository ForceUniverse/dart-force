part of dart_force_client_lib;

class ForceClient extends ForceBaseMessageSendReceiver with ClientSendable {
  Socket socket;
  
  ForceMessageDispatcher _messageDispatcher;
  
  String wsPath;
  
  var _profileInfo = {};
  
  ForceClient({wsPath: "/ws", usePolling: false, url: null}) {
    _messageDispatcher = new ForceMessageDispatcher(this);
    this.wsPath = wsPath;
    if (url==null) {
      url = '${Uri.base.host}:${Uri.base.port}';
    }
    
    this.socket = new Socket('$url$wsPath', usePolling: usePolling, heartbeat: 100);
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
   
  Stream<ForceConnectEvent> get onConnecting =>  this.socket.onConnecting;
}