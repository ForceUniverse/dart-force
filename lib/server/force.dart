part of dart_force_server_lib;

class Force extends ForceBaseMessageSendReceiver with Sendable {

  final Logger log = new Logger('Force');

  static SecurityContextHolder _securityContext = new SecurityContextHolder(new NoSecurityStrategy());
  
  var uuid = new Uuid();
  ForceMessageDispatcher _messageDispatcherInternal;
    
  ForceMessageSecurity messageSecurity = new ForceMessageSecurity(_securityContext);
  StreamController<ForceProfileEvent> _profileController = new StreamController<ForceProfileEvent>();
  
  PollingServer pollingServer = new PollingServer();
  
  void scan() {
      Scanner<Receivable, Object> classesHelper = new Scanner<Receivable, Object>();
      List<Object> classes = ApplicationContext.component(classesHelper);
      
      for (var obj in classes) {
        this.register(obj);
      }
  }
    
  void register(Object obj) {
      MetaDataHelper<Receiver> metaDataHelper = new MetaDataHelper<Receiver>();
      List<MetaDataValue<Receiver>> metaDataValues = metaDataHelper.getMirrorValues(obj);
      
      AnnotationChecker<Authentication> annoChecker = new AnnotationChecker<Authentication>();
      bool auth = annoChecker.hasOnClazz(obj);
      
      for (MetaDataValue mdv in metaDataValues) {
         on(mdv.object.path, (e, sendable) {
            log.info("execute this please!");
            mdv.invoke([e, sendable]);
         }, authentication: auth); 
      }    
  }
  
  /**
   * Handles the abstract Socket implementation of Force, so we can wrap any kind of Socket into this abstract class.
   *  
   **/
  void handle(Socket socket) {
      String id = uuid.v4();
      log.info("register id $id");
      
      this.webSockets[id] = socket;
      this.webSockets[id].onMessage.listen((e) {
        handleMessages(e.request, id, e.data);
      });
      this.webSockets[id].done().then((e) {
        print("ws done");
        checkConnections();
      });
      checkConnections();
  }
    
  void handleMessages(HttpRequest req, String id, data) {
      ForceMessageEvent fme = constructForceMessageEvent(data, wsId: id);
      if (messageSecurity.checkSecurity(req, fme)) {
        _messageDispatch().onMessageDispatch(addMessage(fme));
      } else {
        sendTo(id, "unauthorized", data);
      }
  } 
    
  void before(MessageReceiver messageController) {
      _messageDispatch().before(messageController); 
  }
    
  void on(String request, MessageReceiver messageController, {bool authentication: false}) {
      messageSecurity.register(request, authentication);
      _messageDispatch().register(request, messageController);
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
  
  ForceMessageDispatcher _messageDispatch() {
    if (_messageDispatcherInternal==null) {
      _messageDispatcherInternal = new ForceMessageDispatcher(this); 
    }
    return _messageDispatcherInternal;
  }
    
  Stream<ForceProfileEvent> get onProfileChanged => _profileController.stream;
    
}
