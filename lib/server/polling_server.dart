part of dart_force_server_lib;

class PollingServer {
  
  final Logger log = new Logger('PollingServer');
  
  static String pollingPath(String wsPath) => '$wsPath/polling/';
  
  Map<String, PollingSocket> connections = new Map<String, PollingSocket>();
  StreamController<PollingSocket> _socketController;
  
  PollingServer() {
    _socketController = new StreamController<PollingSocket>();
  }
  
  void uuid(ForceRequest forceRequest, Model model) {
    model.addAttribute("id", new Uuid().v4());
  }
  
  void polling(ForceRequest req, Model model) {
    String pid = req.request.uri.queryParameters['pid'];
    
    checkMessages(req, model, pid);
  }
  
  void checkMessages(ForceRequest req, Model model, pid) {
    PollingSocket pollingSocket = retrieveSocket(pid, req.request);
        
        List messages = new List();
        for (var message in pollingSocket.messages) {
          messages.add(message);
        }
        
        model.addAttributeObject(messages);
        
        pollingSocket.messages.clear();
  }
  
  void sendedData(ForceRequest req, Model model) {
    req.getPostData().then((package) {
      var pid = package["pid"];
      
      PollingSocket pollingSocket = retrieveSocket(pid, req.request);
      if (pollingSocket != null) {
        pollingSocket.sendedData(package["data"]);
      }
    });
    
    var dynamic = {"status" : "ok"};
    model.addAttributeObject(dynamic);
  }
  
  PollingSocket retrieveSocket(pid, HttpRequest req) {
    PollingSocket pollingSocket;
    if (connections.containsKey(pid)) {
      pollingSocket = connections[pid];
      pollingSocket.request = req;
    } else if (pid!=null) {
      print("new polling connection! $pid");
      
      pollingSocket = new PollingSocket(req);
      connections[pid] = pollingSocket;
      _socketController.add(pollingSocket);
    }
    return pollingSocket;
  }
  
  Stream<PollingSocket> get onConnection => _socketController.stream;
}