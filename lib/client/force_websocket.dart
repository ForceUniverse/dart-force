part of dart_force_client_lib;

class ForceWebSocket {
 
  String _url;
  
  AbstractSocket _wsImpl;
  
  ForceWebSocket(this._url) {
    if (WebSocket.supported) {
      _wsImpl = new WebSocketWrapper(_url);
    } else {
      // use long polling!
    }
  }
  
  AbstractSocket get socket => _wsImpl;
  
}