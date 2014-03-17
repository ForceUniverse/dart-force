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
  
  String polling(ForceRequest forceRequest, Model model) {
    String pid = forceRequest.request.uri.queryParameters['pid'];
    
    PollingSocket pollingSocket = retrieveSocket(pid);
    
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