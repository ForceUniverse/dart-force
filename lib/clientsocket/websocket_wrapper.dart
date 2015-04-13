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
      webSocket = new WebSocket('ws://$_url');
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
      _connectController.add(new ConnectEvent());
      webSocket.onMessage.listen((e) {
        if (e.data is Blob) {
          FileReader fileReader = new FileReader();
          fileReader.onLoadEnd.listen((_) =>
              _messageController.add(new SocketEvent(fileReader.result)));

          fileReader.readAsText(e.data);
        } else if (e.data is String) {
          _messageController.add(new SocketEvent(e.data));
        }
      });
    }
    
    void _onDisconnected() {
      print("disconnected!");
      _disconnectController.add(new ConnectEvent());
      if (_connectPending) return;
      _connectPending = true;
      new Timer(RECONNECT_DELAY, connect);
    }
    
    void send(data) {
      webSocket.send(data);
    }
    
    bool isOpen() {
      return webSocket.readyState == WebSocket.OPEN;
    }
}