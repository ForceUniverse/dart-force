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
  
  void polling(HttpRequest req) {
    String pid = req.uri.queryParameters['pid'];
    
    PollingSocket pollingSocket = retrieveSocket(pid);
    var messages = pollingSocket.messages;
    
    var response = req.response;
    String data = JSON.encode(messages);
    response
    ..statusCode = 200
    ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
    //..headers.contentLength = data.length
    ..write(data)
      ..close();
    
    messages.clear();
  }
  
  void sendedData(HttpRequest req) {
    
    req.listen((List<int> buffer) {
      // Return the data back to the client.
      String dataOnAString = new String.fromCharCodes(buffer);
      print(dataOnAString);
      
      var package = JSON.decode(dataOnAString);
      
      var pid = package["pid"];
      
      PollingSocket pollingSocket = retrieveSocket(pid);
      pollingSocket.sendedData(package["data"]);
    });
    
    var response = req.response;
    var dynamic = {"status" : "ok"};
    String data = JSON.encode(dynamic);
    response
    ..statusCode = 200
    ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
    ..headers.contentLength = data.length
    ..write(data)
      ..close();
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