part of dart_force_client_lib;

class WebSocketWrapper extends AbstractSocket {
    static const Duration RECONNECT_DELAY = const Duration(milliseconds: 500);
  
    bool _connectPending = false;
    WebSocket webSocket;
    String _url;
    
    WebSocketWrapper(this._url) {
      _connectController = new StreamController<ForceConnectEvent>();
      _messageController = new StreamController<MessageEvent>();
    }
    
    void connect() {
      _connectPending = false;
      //_connectController = new StreamController<ForceConnectEvent>();
      print("try to connect to this url -> $_url");
      webSocket = new WebSocket(_url);
      webSocket.onOpen.first.then((_) {
        _onConnected();
        webSocket.onClose.first.then((_) {
          print("Connection disconnected to ${webSocket.url}");
          _onDisconnected();
        });
      });
      webSocket.onError.first.then((_) {
        print("Failed to connect to ${webSocket.url}. "
        "Please run bin/server.dart and try again.");
        _onDisconnected();
      });
    }
    
    void _onConnected() {
      print("connected!");
      _connectController.add(new ForceConnectEvent("connected"));
      print("wicked new ForceEvent no ? ? !");
      webSocket.onMessage.listen((e) {
        _messageController.add(e);
      });
    }
    
    void _onDisconnected() {
      print("disconnected!");
      _connectController.add(new ForceConnectEvent("disconnected"));
      if (_connectPending) return;
      _connectPending = true;
      new Timer(RECONNECT_DELAY, connect);
    }
    
    void send(data) {
      webSocket.send(data);
    }
}