part of dart_force_server_lib;

class ServerSendable implements Sendable {

 final Logger log = new Logger('Sendable');
  
  Map<String, ForceSocket> webSockets = new Map<String, ForceSocket>();
  Map<String, dynamic> profiles = new Map<String, dynamic>();
  
  MessagesConstructHelper _messagesConstructHelper = new MessagesConstructHelper();
    
  void send(request, data) {
    printAmountOfConnections();
    
    var sendingPackage = _messagesConstructHelper.send(request, data);
    
    webSockets.forEach((String key, ForceSocket ws) {
      log.info("broadcasting ... to $key");
      ws.add(JSON.encode(sendingPackage));
    });
  }
  
  void broadcast(request, data) {
      printAmountOfConnections();
      
      var sendingPackage = _messagesConstructHelper.broadcast(request, data);
      
      webSockets.forEach((String key, ForceSocket ws) {
        log.info("broadcasting ... to $key");
        ws.add(JSON.encode(sendingPackage));
      });
    }
  
  void sendTo(id, request, data) {
    log.info("*** send to $id");
    ForceSocket ws = webSockets[id];
    var sendingPackage = _messagesConstructHelper.send(request, data);
    
    if (ws != null) {
      ws.add(JSON.encode(sendingPackage));
    }
  }
  
  void sendToProfile(key, value, request, data) {
    List<String> ids = new List<String>();
    profiles.forEach((String id, profile_data) {
      if (profile_data[key] == value) {
        ids.add(id);
      }
    });
    if (ids.isNotEmpty) {
      for (String id in ids) {
        sendTo(id, request, data);
      }
    }
  }
  
  void printAmountOfConnections() {
    int size = this.webSockets.length;
    log.info("*** total amount of sockets: $size");
  }

}