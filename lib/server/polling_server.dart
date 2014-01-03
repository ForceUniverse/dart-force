part of dart_force_server_lib;

class PollingServer {
  
  final Logger log = new Logger('PollingServer');
  
  Router router;
  String wsPath;
  
  Map<String, PollingSocket> connections = new Map<String, PollingSocket>();
  StreamController<PollingSocket> _socketController;
  
  PollingServer(this.router, this.wsPath) {
    print('start long polling server ... $wsPath/polling');
    router.serve('$wsPath/polling', method: "GET").listen(polling);
    router.serve('$wsPath/polling', method: "POST").listen(sendedData);
    
    _socketController = new StreamController<PollingSocket>();
  }
  
  void polling(HttpRequest req) {
    String pid = req.uri.queryParameters['pid'];
    
    PollingSocket pollingSocket = retrieveSocket(pid);
    var messages = pollingSocket.messages;
    
    var response = req.response;
    String data = JSON.encode(messages);
    try {  
      response
      ..statusCode = 200
      ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
      ..headers.contentLength = data.length
      ..write(data)
        ..close();
      
      messages.clear();
    } catch (ex) {
      print("Could not react on poll request content $data");
    }
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
    try {
      response
      ..statusCode = 200
      ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
      ..headers.contentLength = data.length
      ..write(data)
        ..close();
    } catch (ex) {
      print("Could not handle sended data content $data");
    }
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