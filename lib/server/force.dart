part of force.server;

class Force extends Object with ServerSendable {

  final Logger log = new Logger('Force');

  static SecurityContextHolder _securityContext = new SecurityContextHolder(new NoSecurityStrategy());
  
  var uuid = new Uuid();
  // ForceMessageDispatcher _messageDispatcherInternal;
  
  ForceMessageSecurity messageSecurity = new ForceMessageSecurity(_securityContext);
  StreamController<ForceProfileEvent> _profileController = new StreamController<ForceProfileEvent>();
  
  PollingServer pollingServer = new PollingServer();
  
  /// When a new Socket is been created a new [SocketEvent] will be added.
  StreamController<SocketEvent> _onSocket = new StreamController<SocketEvent>.broadcast();
  
  /// When a Socket connection is been closed a new [SocketEvent] will be added.
  StreamController<SocketEvent> _onSocketClosed = new StreamController<SocketEvent>.broadcast();
  
  /// List of special connectors
  List<Connector> connectors = new List<Connector>();
  
  ForceContext _forceContext;
  
  Duration _keepAliveTime;
  
  /**
   * The register method provides a way to add objects that contain the [Receiver] annotation, 
   * these methods are then executed when the request value match an incoming message. 
   *  
   **/
  void scan() {
      Scanner<_Receivable> classesHelper = new Scanner<AnnoReceivable>();
      
      List<Object> classes = ApplicationContext.addComponents(classesHelper.scan());
      
      for (var obj in classes) {
        this.register(obj);
      }
  }
  
  /**
   * Add a keep alive to the Socket lifecycle of a WebSocket
   */
  void activateKeepAlive({int seconds: 40}) {
    _keepAliveTime = new Duration(seconds: seconds);
    log.info("Keep alive is been activated with a ping pong at ${seconds} seconds.");
  }
   
  /**
   * The register method provides a way to add objects that contain the [Receiver] annotation, 
   * these methods are then executed when the request value match an incoming message. 
   * 
   * So this will turn 
   * 
   * @Receiver("request")
   * void whenRequest(e, sendable) {}
   * 
   * into 
   * 
   * on("request", (e, sendable) {} 
   *
   * 
    **/
  void register(Object obj) {
      MetaDataHelper<Receiver, MethodMirror> metaDataHelper = new MetaDataHelper<Receiver, MethodMirror>();
      List<MetaDataValue<Receiver>> metaDataValues = metaDataHelper.from(obj);
      
      var auth = MVCAnnotationHelper.getAuthentication(obj);
      
      var _ref; //Variable to check null values
      var roles = (auth != null ? auth.roles : null);
      
      // then look at Pr eAuthorizeRoles, when they are defined
      roles = (_ref = new AnnotationScanner<PreAuthorizeRoles>().instanceFrom(obj))== null ? null : _ref.roles;
      
      for (MetaDataValue mdv in metaDataValues) { 
        on(mdv.object.request, (e, sendable) {
            log.info("execute this please!");
            mdv.invoke([e, sendable]);
         }, roles: roles); 
      }    
      
      // Look for new connection annotations
      MetaDataHelper<_NewConnection, MethodMirror> newConnectionMetaDataHelper = new MetaDataHelper<_NewConnection, MethodMirror>();
      List<MetaDataValue<_NewConnection>> ncMetaData = newConnectionMetaDataHelper.from(obj);
      
      _invokeMetaDataSocketEvent(_onSocket.stream, ncMetaData);
      
      // Look for close connection annotations
      MetaDataHelper<_ClosedConnection, MethodMirror> closedConnectionMetaDataHelper = new MetaDataHelper<_ClosedConnection, MethodMirror>();
      List<MetaDataValue<_ClosedConnection>> ccMetaData = closedConnectionMetaDataHelper.from(obj);
      
      _invokeMetaDataSocketEvent(_onSocketClosed.stream, ccMetaData);
  }
  
  void _invokeMetaDataSocketEvent(Stream stream, List<MetaDataValue> metaData) {
      stream.listen((SocketEvent se) {
            for (MetaDataValue mdv in metaData) {
              mdv.invoke([se.wsId, se.socket]);
            }
      });
  }
  
  /**
   * Handles the abstract Socket implementation of Force, so we can wrap any kind of Socket into this abstract class.
   *  
   **/
  void handle(ForceSocket socket) {
      String id = uuid.v4();
      log.info("register id $id");
      
      this.forceSockets[id] = socket;
      this.forceSockets[id].onMessage.listen((e) {
        handleMessages(e.request, id, e.data);
      });
      this.forceSockets[id].done().then((e) {
        log.info("socket ended");
        checkConnections();
      });
      _startNewConnection(id, socket);
  }
  
  void _startNewConnection(String socketId, ForceSocket socket) {
    checkConnections();
    _onSocket.add(new SocketEvent(socketId, socket));
    // send a first message to the newly connected socket
    this.sendTo(socketId, "ack", "ack");
  }
  
  /**
   * Handles the messages that are coming into the server, regulator.
   */
  void handleMessages(HttpRequest req, String id, data) {
    List packages = _lazyContext().protocolDispatchers().convertPackages(data, wsId: id); 
    for(var package in packages) {
      if (messageSecurity.isAuthorized(req, package)) {
        _lazyContext().protocolDispatchers().dispatch(package);
      } else {
        sendTo(id, "unauthorized", data);
      }
    }
  } 
   
  /**
   * This will be executed before the on method.
   * 
   * It will be executed before every message that is been send. This method can help with intercept the message before it goes into the loop.
   *  
   **/
  void before(MessageReceiver messageController) {
    _lazyContext().messageDispatch().before(messageController); 
  }
    
  /**
   * You can use this method when you want to do something when a message comes in for a certain request.
   * 
   * So imagine you want to do something when a message with request 'info' comes in. Then you can do it like this.
   * 
   * on('info', (e, sendable) {
   *    sendable.send("received", { "data": "ok" });
   * });
   * 
   **/
  void on(String request, MessageReceiver messageController, {List<String> roles}) {
      messageSecurity.register(request, roles);
      _lazyContext().messageDispatch().register(request, messageController);
  }
  
  /**
   * You can publish a collection so it is been know in the system and also filter CargoPackages before it gets dispatched
   * 
   * So when bad data comes in you can anticipate before adding it into the Cargo Persistent Store (Mongo, Memory, File, ...)
   * 
   * publish('todos', cargoInstance, (ForceCargoPackage fcp) {
   *    if (fcp.action = ActionType.ADD) {
   *      
   *    }
   * });
   */
  CargoBase publish(String collection, CargoBase cargo, {ValidateCargoPackage validate}) {    
    CargoBase cargoWithCollection = cargo.instanceWithCollection(collection);
    _lazyContext().cargoPacakgeDispatcher().publish(collection, cargoWithCollection, filter: validate);
    return cargoWithCollection;
    
  }
    
  /**
   * Close a specific websocket connection.
   * 
   **/
  void close(String id) {
      if (forceSockets.containsKey(id)) {
        this.forceSockets[id].close();
      }
      checkConnections();
  }
    
  /**
   * check all the connections if they are still all active, otherwise these connections will be closed and removed from the websockets list.
   * 
   **/
  void checkConnections() {
      List<String> removeWs = new List<String>();
      this.forceSockets.forEach((String key, ForceSocket ws) {
        if (ws.isClosed()) {
          removeWs.add(key);
        }
      });
      
      _removeWsConnections(removeWs);
  }
    
  void _removeWsConnections(List<String> removeWs) {
      printAmountOfConnections();
      
      for (String wsId in removeWs) {
        _onSocketClosed.add(new SocketEvent(wsId, this.forceSockets[wsId]));
        this.forceSockets.remove(wsId);
        if (this.profiles.containsKey(wsId)) {
          _profileController.add(new ForceProfileEvent(ForceProfileType.Removed, wsId, this.profiles[wsId]));
          
          this.profiles.remove(wsId);
        }
      } 
  }
  
  void addConnector(Connector connector) {
    connectors.add(connector);
    
    connector.wire().listen((ForceSocket forceSocket) {
      handle(forceSocket);
      
      connector.complete();
    });
  }
  
  void addProtocol(Protocol protocol) {
    _lazyContext().protocolDispatchers().addProtocol(protocol);
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
  
  ForceContext _lazyContext() {
    if (_forceContext==null) {
      _forceContext = new ForceContext(this);
    }
    return _forceContext;
  }
    
  Stream<ForceProfileEvent> get onProfileChanged => _profileController.stream;
  
  /// When a new socket is been created
  Stream<SocketEvent> get onSocket => _onSocket.stream;
  
  /// When a socket connection is been closed
  Stream<SocketEvent> get onClosed => _onSocketClosed.stream;
  
}
