part of dart_force_client_lib;

class ForceClient extends ForceBaseMessageSendReceiver implements Sender {
  static const Duration RECONNECT_DELAY = const Duration(milliseconds: 500);
  
  bool _connectPending = false;
  WebSocket webSocket;
  
  StreamController<ForceConnectEvent> _connectController;
  
  ForceMessageDispatcher _messageDispatcher;
  
  String wsPath;
  
  var _profileInfo = {};
  
  ForceClient({wsPath: "/ws"}) {
    _connectController = new StreamController<ForceConnectEvent>();
    _messageDispatcher = new ForceMessageDispatcher(this);
    this.wsPath = wsPath;
  }
  
  void connect() {
    _connectPending = false;
    _connectController = new StreamController<ForceConnectEvent>();
    webSocket = new WebSocket('ws://${Uri.base.host}:${Uri.base.port}$wsPath');
    webSocket.onOpen.first.then((_) {
      onConnected();
      webSocket.onClose.first.then((_) {
        print("Connection disconnected to ${webSocket.url}");
        onDisconnected();
      });
    });
    webSocket.onError.first.then((_) {
      print("Failed to connect to ${webSocket.url}. "
            "Please run bin/server.dart and try again.");
      onDisconnected();
    });
  }
  
  void onConnected() {
    print("connected!");
    _connectController.add(new ForceConnectEvent("connected"));
    webSocket.onMessage.listen((e) {
      _messageDispatcher.onMessageDispatch(onInnerMessage(e.data));
    });
  }
  
  void onDisconnected() {
    print("disconnected!");
    _connectController.add(new ForceConnectEvent("disconnected"));
    if (_connectPending) return;
    _connectPending = true;
    new Timer(RECONNECT_DELAY, connect);
  }
  
  void on(String request, MessageReceiver vaderMessageController) {
    _messageDispatcher.register(request, vaderMessageController);
  }
  
  void initProfileInfo(profileInfo) {
    _profileInfo = profileInfo;
    send('profileInfo', {});
  }
  
  void send(request, data) {
    var sendingPackage =  {
        'request': request,
        'profile': _profileInfo,
        'data': data
    };
    this._send(sendingPackage);
  }
  
  void sendTo(id, request, data) {
     var sendingPackage =  {
          'request': request,
          'profile': _profileInfo,
          'id': id,
          'data': data
     };
     this._send(sendingPackage);
  }
  
  void _send(sendingPackage) {
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      webSocket.send(JSON.encode(sendingPackage));
    } else {
      print('WebSocket not connected, message $sendingPackage not sent');
    }
  }
   
  Stream<ForceConnectEvent> get onConnecting => _connectController.stream;
}