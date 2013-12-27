part of dart_force_client_lib;

class ForceWebSocket {
  
  static AbstractSocket createSocket(String url) {
    if (WebSocket.supported) {
      return new WebSocketWrapper(url);
    } else {
      return new PollingSocket(url);
    }
  }
}