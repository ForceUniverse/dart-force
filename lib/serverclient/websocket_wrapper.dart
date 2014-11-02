part of dart_force_client_lib;

class WebSocketWrapper extends Socket {
    static const Duration RECONNECT_DELAY = const Duration(milliseconds: 500);
  
    bool _connectPending = false;
    WebSocket webSocket;
    
    String _url;
    
    WebSocketWrapper(this._url) : super._() {
      _connectController = new StreamController<ConnectEvent>();
      _disconnectController = new StreamController<ConnectEvent>();
      _messageController = new StreamController<SocketEvent>();
    }
    
    void connect() {
      _connectPending = false;
      //print("try to connect to this url -> $_url");
      WebSocket.connect('ws://$_url').then((socket) {
        webSocket = socket;
        _onConnected();
      });

    }
    
    void _onConnected() {
      print("connected!");
      _connectController.add(new ConnectEvent());
      webSocket.listen((data) {
          _messageController.add(new SocketEvent(data));
      }, onDone: _onDisconnected);
    }
    
    void _onDisconnected() {
      print("disconnected!");
      _disconnectController.add(new ConnectEvent());
      if (_connectPending) return;
      _connectPending = true;
      new Timer(RECONNECT_DELAY, connect);
    }
    
    void send(data) {
      webSocket.add(data);
    }
    
    bool isOpen() {
      if (webSocket == null) {
        return false;
      }
      return webSocket.readyState == WebSocket.OPEN;
    }
}