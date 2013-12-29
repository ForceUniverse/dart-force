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
  }
  
  void polling(HttpRequest req) {
    print("get data from longpolling!");
    
    String pid = req.uri.queryParameters['pid'];
    print("get pid? $pid");
    PollingSocket pollingSocket;
    if (connections.containsKey(pid)) {
      pollingSocket = connections[pid];
    } else {
      connections[pid] = pollingSocket;
      _socketController.add(pollingSocket);
    }
    
    var messages = pollingSocket.messages;
    
    var response = req.response;
    String data = JSON.encode(messages);
    response
    ..statusCode = 200
    ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
    ..headers.contentLength = data.length
    ..write(data)
      ..close();
    
    messages.clear();
  }
  
  void sendedData(HttpRequest req) {
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
  
  Stream<PollingSocket> get onConnection => _socketController.stream;
}