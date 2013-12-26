part of dart_force_client_lib;

class ForceClient extends ForceBaseMessageSendReceiver with ClientSendable {
  AbstractSocket webSocketWrapper;
  
  ForceMessageDispatcher _messageDispatcher;
  
  String wsPath;
  
  var _profileInfo = {};
  
  ForceClient({wsPath: "/ws"}) {
    _messageDispatcher = new ForceMessageDispatcher(this);
    this.wsPath = wsPath;
    
    this.webSocketWrapper = ForceWebSocket.createSocket('${Uri.base.host}:${Uri.base.port}$wsPath');
  }
  
  void connect() {
   this.webSocketWrapper.connect();
   this.webSocketWrapper.onMessage.listen((e) {
     _messageDispatcher.onMessageDispatch(onInnerMessage(e.data));
   });
  }
  
  void on(String request, MessageReceiver vaderMessageController) {
    _messageDispatcher.register(request, vaderMessageController);
  }
   
  Stream<ForceConnectEvent> get onConnecting =>  this.webSocketWrapper.onConnecting;
}