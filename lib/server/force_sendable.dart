part of dart_force_server_lib;

class Sendable implements Sender {

 final Logger log = new Logger('VaderMessageServer');
  
  Map<String, WebSocket> webSockets;
  
  void send(request, data) {
    printAmountOfConnections();
    
    var sendingPackage =  {
          'request': request,
          'data': data
      };
    
    webSockets.forEach((String key, WebSocket ws) {
      print("breadcasting ... to $key");
      ws.add(JSON.encode(sendingPackage));
    });
  }
  
  void sendTo(id, request, data) {
    log.info("*** send to $id");
    WebSocket ws = webSockets[id];
    var sendingPackage =  {
          'request': request,
          'data': data
    };
    ws.add(JSON.encode(sendingPackage));
  }
  
  void printAmountOfConnections() {
    int size = this.webSockets.length;
    log.info("*** total amount of ws $size");
  }

}