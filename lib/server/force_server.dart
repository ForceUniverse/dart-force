part of dart_force_server_lib;

class ForceServer extends Force with Serveable { 
  
  final Logger log = new Logger('ForceServer');

  WebServer _basicServer;
  
  ForceServer({host: "127.0.0.1",          
               port: 8080,
               wsPath: "/ws",
               clientFiles: '../client/',
               clientServe: true,
               startPage: "index.html"}) {
    _basicServer = new WebServer(host: host,
                                 port: port,
                                 wsPath: wsPath, 
                                 clientFiles: clientFiles,
                                 clientServe: clientServe,
                                 startPage: startPage); 
    messageSecurity = new ForceMessageSecurity(_basicServer.securityContext);
    
    scan();

    // listen on info from the client
    this.before(_checkProfiles);
    
    // start pollingServer
    pollingServer.onConnection.listen((PollingSocket socket) {
      handle(socket);
    });
    
    this.server.on('$wsPath/uuid/', pollingServer.retrieveUuid, method: "GET");
    this.server.on(PollingServer.pollingPath(wsPath), pollingServer.polling, method: "GET");
    this.server.on(PollingServer.pollingPath(wsPath), pollingServer.sendedData, method: "POST");
  }
  
  Future start() {
    return _basicServer.start((WebSocket ws, HttpRequest req) {
      handle(new WebSocketWrapper(ws, req)); 
    });
  }
  
  void setupConsoleLog([Level level = Level.INFO]) {
    _basicServer.setupConsoleLog(level);
  }

  WebServer get server => _basicServer;
  
}

