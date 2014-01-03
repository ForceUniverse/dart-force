part of dart_force_client_lib;

class ForceClient extends ForceBaseMessageSendReceiver with ClientSendable {
  Socket socket;
  
  ForceMessageDispatcher _messageDispatcher;
  
  String wsPath;
  
  var _profileInfo = {};
  
  ForceClient({wsPath: "/ws", usePolling: false}) {
    _messageDispatcher = new ForceMessageDispatcher(this);
    this.wsPath = wsPath;
    
    this.socket = new Socket('${Uri.base.host}:${Uri.base.port}$wsPath', usePolling: usePolling);
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