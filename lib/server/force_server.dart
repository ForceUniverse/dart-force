part of dart_force_server_lib;

class ForceServer extends ForceBaseMessageSendReceiver 
                                  with Serveable, Sendable { 
  
  final Logger log = new Logger('ForceServer');

  var uuid = new Uuid();
  WebServer _basicServer;
  ForceMessageDispatcher messageDispatcher;
  
  StreamController<ForceProfileEvent> _profileController;
  
  ForceServer({wsPath: "/ws", port: 8080, host: null, buildPath: '../build', startPage: "index.html" }) {
    _basicServer = new WebServer(wsPath: wsPath, port: port, host: host, buildPath: buildPath);
    _basicServer.startPage = startPage;
    webSockets = new Map<String, Socket>();
    
    messageDispatcher = new ForceMessageDispatcher(this);
    
    // Profiles
    profiles = new Map<String, dynamic>();
    _profileController = new StreamController<ForceProfileEvent>();
    
    // listen on info from the client
    this.before(_checkProfiles);
    
    // start pollingServer
    PollingServer pollingServer = new PollingServer(wsPath, _basicServer);
    pollingServer.onConnection.listen((PollingSocket socket) {
      handleWs(socket);
    });
  }
  
  Future start() {
    return _basicServer.start((WebSocket ws) {
      handleWs(new WebSocketWrapper(ws)); 
    });
  }
  
  void register(Object obj) {
    MetaDataHelper<Receiver> metaDataHelper = new MetaDataHelper<Receiver>();
    List<MetaDataValue<Receiver>> metaDataValues = metaDataHelper.getMirrorValues(obj);
    
    for (MetaDataValue mdv in metaDataValues) {
       on(mdv.object.path, (e, sendable) {
          log.info("execute this please!");
          InstanceMirror res = mdv.instanceMirror.invoke(mdv.memberName, [e, sendable]);
       }); 
    }    
  }
  
  void handleWs(Socket webSocket) {
    String id = uuid.v4();
    log.info("register id $id");
    
    this.webSockets[id] = webSocket;
    this.webSockets[id].onMessage.listen((e) {
      handleMessages(id, e.data);
    });
    this.webSockets[id].done().then((e) {
      print("ws done");
      checkConnections();
    });
    checkConnections();
  }
  
  void handleMessages(String id, data) {
    messageDispatcher.onMessageDispatch(onInnerMessage(data, wsId: id));
  } 
  
  void before(MessageReceiver messageController) {
    messageDispatcher.before(messageController); 
  }
  
  void on(String request, MessageReceiver messageController) {
    messageDispatcher.register(request, messageController);
  }
  
  void close(String id) {
    if (webSockets.containsKey(id)) {
      this.webSockets[id].close();
    }
    checkConnections();
  }
  
  void checkConnections() {
    List<String> removeWs = new List<String>();
    this.webSockets.forEach((String key, Socket ws) {
      if (ws.isClosed()) {
        removeWs.add(key);
      }
    });
    
    removeWsConnections(removeWs);
  }
  
  void removeWsConnections(List<String> removeWs) {
    printAmountOfConnections();
    
    for (String wsId in removeWs) {
      this.webSockets.remove(wsId);
      if (this.profiles.containsKey(wsId)) {
        _profileController.add(new ForceProfileEvent(ForceProfileType.Removed, wsId, this.profiles[wsId]));
        
        this.profiles.remove(wsId);
      }
    } 
  }
  
  void _checkProfiles(e, sendable) {
      if (e.profile != null) {
        if (!profiles.containsKey(e.wsId)) {
            _profileController.add(new ForceProfileEvent(ForceProfileType.New, e.wsId, e.profile));
        } else {
          // look at the difference with current profile
          Map oldProfile = profiles[e.wsId];
          Map newProfile = e.profile;
          newProfile.forEach((key, value) {
            if (oldProfile.containsKey(key)) {
              if (oldProfile[key]!=value) {
                _profileController.add(new ForceProfileEvent(ForceProfileType.ChangedProperty, e.wsId, e.profile, property: new ForceProperty(key, oldProfile[key])));
              }
            } else {
              _profileController.add(new ForceProfileEvent(ForceProfileType.NewProperty, e.wsId, e.profile,  property: new ForceProperty(key, value)));
            }
          });
        }
        profiles[e.wsId] = e.profile;
      }
  }
  
  Stream<ForceProfileEvent> get onProfileChanged => _profileController.stream;
  
  WebServer get server => _basicServer;
}