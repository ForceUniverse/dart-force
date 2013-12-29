part of dart_force_client_lib;

class ForceWebSocket {
  
  static AbstractSocket createSocket(String url, {usePolling: false}) {
    print("choose a socket implementation!");
    if (usePolling || !WebSocket.supported) {
      return new PollingSocket(url);
    } else {
      return new WebSocketWrapper(url);
    }
  }
}