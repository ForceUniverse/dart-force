part of dart_force_server_lib;

class PollingServer {
  
  final Logger log = new Logger('PollingServer');
  
  String wsPath;
  WebServer server;
  
  Map<String, PollingSocket> connections = new Map<String, PollingSocket>();
  StreamController<PollingSocket> _socketController;
  
  PollingServer(this.wsPath, this.server) {
    print('start long polling server ... $wsPath/polling');
    String pollingPath = '$wsPath/polling';
    
    this.server.on(pollingPath, polling, method: "GET");
    this.server.on(pollingPath, sendedData, method: "POST");
    _socketController = new StreamController<PollingSocket>();
  }
  
  String polling(HttpRequest req, Model model) {
    String pid = req.uri.queryParameters['pid'];
    
    PollingSocket pollingSocket = retrieveSocket(pid);
    var messages = pollingSocket.messages;
    
    model.addAttributeObject(messages);
    
    pollingSocket.messages.clear();
  }
  
  String sendedData(HttpRequest req, Model model) {
    req.listen((List<int> buffer) {
      // Return the data back to the client.
      String dataOnAString = new String.fromCharCodes(buffer);
      print(dataOnAString);
      
      var package = JSON.decode(dataOnAString);
      
      var pid = package["pid"];
      
      PollingSocket pollingSocket = retrieveSocket(pid);
      pollingSocket.sendedData(package["data"]);
    });
    
    var dynamic = {"status" : "ok"};
    model.addAttributeObject(dynamic);
  }
  
  PollingSocket retrieveSocket(pid) {
    PollingSocket pollingSocket;
    if (connections.containsKey(pid)) {
      pollingSocket = connections[pid];
    } else {
      print("new polling connection! $pid");
      
      pollingSocket = new PollingSocket();
      connections[pid] = pollingSocket;
      _socketController.add(pollingSocket);
    }
    return pollingSocket;
  }
  
  Stream<PollingSocket> get onConnection => _socketController.stream;
}