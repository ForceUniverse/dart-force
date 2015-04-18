part of dart_force_server_lib;

class PollingServer {
  
  final Logger log = new Logger('PollingServer');
  
  static String pollingPath(String wsPath) => '$wsPath/polling/';
  
  Map<String, PollingSocket> connections = new Map<String, PollingSocket>();
  StreamController<PollingSocket> _socketController;
  
  PollingServer() {
    _socketController = new StreamController<PollingSocket>();
  }
  
  void retrieveUuid(ForceRequest forceRequest, Model model) {
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
  
  Future sendedData(ForceRequest req, Model model) {
    req.getPostData().then((package) {
      var pid = package["pid"];
      
      PollingSocket pollingSocket = retrieveSocket(pid, req.request);
      if (pollingSocket != null) {
        pollingSocket.sendedData(package["data"]);
      }
      
      req.async({"status" : "ok"});
    }).catchError((err) {
      print("$err");
    });;
    
    return req.asyncFuture;
  }
  
  PollingSocket retrieveSocket(pid, HttpRequest req) {
    PollingSocket pollingSocket;
    if (connections.containsKey(pid)) {
      pollingSocket = connections[pid];
      pollingSocket.request = req;
    } else if (pid!=null) {
      log.info("new polling connection! $pid");
      
      pollingSocket = new PollingSocket(req);
      connections[pid] = pollingSocket;
      _socketController.add(pollingSocket);
    }
    return pollingSocket;
  }
  
  Stream<PollingSocket> get onConnection => _socketController.stream;
}