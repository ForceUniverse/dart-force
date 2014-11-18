part of dart_force_server_lib;

class ServerSendable implements Sendable, DataChangeable {

    final Logger log = new Logger('Sendable');
  
    Map<String, ForceSocket> webSockets = new Map<String, ForceSocket>();
    Map<String, dynamic> profiles = new Map<String, dynamic>();
    
    MessagesConstructHelper _messagesConstructHelper = new MessagesConstructHelper();
      
    void send(request, data) {
      printAmountOfConnections();
      
      var sendingPackage = _messagesConstructHelper.send(request, data);
      _sendPackage(sendingPackage);
    }
  
    void broadcast(request, data) {
        printAmountOfConnections();
        
        var sendingPackage = _messagesConstructHelper.broadcast(request, data);
        _sendPackage(sendingPackage);
    }
    
    void sendTo(id, request, data) {
      log.info("*** send to $id");
      
      var sendingPackage = _messagesConstructHelper.send(request, data);
      _sendPackageToId(id, sendingPackage);
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
  
    // DATA PROTOCOL
    void add(collection, key, data, {id}) {
        var sendingPackage = _messagesConstructHelper.add(collection, key, data);
        _sendPackageToId(id, sendingPackage);
    }
    
    void update(collection, key, data, {id}) {
        var sendingPackage = _messagesConstructHelper.update(collection, key, data);
        _sendPackageToId(id, sendingPackage);
    }
    
    void remove(collection, key, data, {id}) {
        var sendingPackage = _messagesConstructHelper.update(collection, key, data);
        _sendPackageToId(id, sendingPackage);
    }
    
    // OVERALL METHODS
    void _sendPackage(sendingPackage) {
      webSockets.forEach((String key, ForceSocket ws) {
              log.info("sending package ... to $key");
              ws.add(JSON.encode(sendingPackage));
            });
    }
    
    void _sendPackageToId(id, sendingPackage) {
      ForceSocket ws = webSockets[id];
            if (ws != null) {
              ws.add(JSON.encode(sendingPackage));
            }
    }
  
  void printAmountOfConnections() {
    int size = this.webSockets.length;
    log.info("*** total amount of sockets: $size");
  }

}