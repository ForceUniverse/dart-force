part of dart_force_server_lib;

class PollingServer {
  
  final Logger log = new Logger('PollingServer');
  
  String wsPath;
  WebServer server;
  
  Map<String, PollingSocket> connections = new Map<String, PollingSocket>();
  StreamController<PollingSocket> _socketController;
  
  PollingServer(this.wsPath, this.server) {
    print('start long polling server ... $wsPath/polling/');
    String pollingPath = '$wsPath/polling/';
    
    this.server.on('$wsPath/uuid/', uuid, method: "GET");
    this.server.on(pollingPath, polling, method: "GET");
    this.server.on(pollingPath, sendedData, method: "POST");
    _socketController = new StreamController<PollingSocket>();
  }
  
  String uuid(ForceRequest forceRequest, Model model) {
    model.addAttribute("id", new Uuid().v4());
  }
  
  String polling(ForceRequest req, Model model) {
    String pid = req.request.uri.queryParameters['pid'];
    
    PollingSocket pollingSocket = retrieveSocket(pid, req.request);
    
    List messages = new List();
    for (var message in pollingSocket.messages) {
      messages.add(message);
    }
    
    model.addAttributeObject(messages);
    
    pollingSocket.messages.clear();
  }
  
  String sendedData(ForceRequest req, Model model) {
    req.getPostData().then((package) {
      var pid = package["pid"];
      
      PollingSocket pollingSocket = retrieveSocket(pid, req.request);
      pollingSocket.sendedData(package["data"]);
    });
    
    var dynamic = {"status" : "ok"};
    model.addAttributeObject(dynamic);
  }
  
  PollingSocket retrieveSocket(pid, HttpRequest req) {
    PollingSocket pollingSocket;
    if (connections.containsKey(pid)) {
      pollingSocket = connections[pid];
      pollingSocket.request = req;
    } else {
      print("new polling connection! $pid");
      
      pollingSocket = new PollingSocket(req);
      connections[pid] = pollingSocket;
      _socketController.add(pollingSocket);
    }
    return pollingSocket;
  }
  
  Stream<PollingSocket> get onConnection => _socketController.stream;
}