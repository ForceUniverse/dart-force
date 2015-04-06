part of dart_force_server_lib;

class ForceServer extends Force with Serveable { 
  
  final Logger log = new Logger('ForceServer');

  WebApplication _basicServer;
  
  bool keepAlive = false;
  
  ForceServer({host: "127.0.0.1",          
               port: 8080,
               wsPath: "/ws",
               clientFiles: '../build/web/', 
               clientServe: true,
               this.keepAlive: false,
               startPage: 'index.html'}) {
    _basicServer = new WebApplication(host: host,
                                 port: port,
                                 wsPath: wsPath, 
                                 clientFiles: clientFiles,
                                 startPage: startPage,
                                 clientServe: clientServe); 
    messageSecurity = new ForceMessageSecurity(_basicServer.securityContext);
    
    scan();

    // listen on info from the client
    this.before(_checkProfiles);
    
    // start pollingServer
    pollingServer.onConnection.listen((PollingSocket socket) {
      handle(socket);
    });
    
    this.server.use('$wsPath/uuid/', pollingServer.retrieveUuid, method: "GET");
    this.server.use(PollingServer.pollingPath(wsPath), pollingServer.polling, method: "GET");
    this.server.use(PollingServer.pollingPath(wsPath), pollingServer.sendedData, method: "POST");
  }
  
  /**
   * This method will start the server.
   * @param FallbackStart when a start fails, you can implement what the application needs todo to restart randomPortFallback is an example.
   * 
   * @return a future when the server is been started.
   */
  Future start({FallbackStart fallback}) {
    return _basicServer.start(handleWs: this._socketsHandler, fallback: fallback);
  }
  
  void _socketsHandler(WebSocket ws, HttpRequest req) {
      if (this.keepAlive) ws.pingInterval = new Duration(seconds: 45);
      handle(new WebSocketWrapper(ws, req)); 
  } 
  
  /**
   * This requestHandler can be used to hook into the system without having to start a server.
   * You need to use this method for example with Google App Engine runtime.
   * 
   * @param request is the current HttpRequest that needs to be handled by the system.
   */
  void requestHandler(HttpRequest request) {
      _basicServer.requestHandler(request, this._socketsHandler);
  } 
  
  /**
   * Activate server logging in forcemvc
   * 
   * @param the level of login
   */
  void setupConsoleLog([Level level = Level.INFO]) {
    _basicServer.setupConsoleLog(level);
  }

  WebApplication get server => _basicServer;
  
}

