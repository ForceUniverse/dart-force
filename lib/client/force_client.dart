part of dart_force_client_lib;

class ForceClient extends Object with ClientSendable {
  Socket socket;
  String wsPath;
 
  ProtocolDispatchers protocolDispatchers = new ProtocolDispatchers();
  CargoHolder _cargoHolder;
  ForceMessageDispatcher _forceMessageDispatcher;
  
  var _profileInfo = {};
  
  ForceClient({String wsPath: "/ws", String url: null, String host: null, String port: null, int heartbeat: 500, bool usePolling: false}) {
    print("create a forceclient");
    _setupProtocols(); 
    this.wsPath = wsPath;
    if (host==null) {
      host = '${Uri.base.host}';
    }
    if (port==null) {
      port = '${Uri.base.port}';
    }
    if (url==null) {
      url = '$host:$port';
    }
    
    this.socket = new Socket('$url$wsPath', usePolling: usePolling, heartbeat: heartbeat);
    this.messenger = new BrowserMessenger(socket);
  }
  
  void _setupProtocols() {
    _cargoHolder = new CargoHolderClient(this);
    _forceMessageDispatcher = new ForceMessageDispatcher(this);
    ForceMessageProtocol forceMessageProtocol = new ForceMessageProtocol(_forceMessageDispatcher);
    protocolDispatchers.protocols.add(forceMessageProtocol);
    // add Cargo
    CargoPackageDispatcher cargoPacakgeDispatcher = new CargoPackageDispatcher(_cargoHolder);
    ForceCargoProtocol forceCargoProtocol = new ForceCargoProtocol(cargoPacakgeDispatcher);
    protocolDispatchers.protocols.add(forceCargoProtocol);
  }
  
  ViewCollection register(String collection, CargoBase cargo, {Map params}) {
    CargoBase cargoWithCollection = cargo.instanceWithCollection(collection);
    _cargoHolder.publish(collection, cargoWithCollection);
    this.subscribe(collection, params: params);
    
    return new ViewCollection(collection, cargoWithCollection, this);
  }
  
  void connect() {
   this.socket.connect();
   this.socket.onMessage.listen((e) {
     protocolDispatchers.dispatch_raw(e.data);
   });
  }
  
  void on(String request, MessageReceiver forceMessageController) {
    _forceMessageDispatcher.register(request, forceMessageController);
  }
  
  dynamic generateId() {
    var rng = new Random();
    return rng.nextInt(10000000);
  }
   
  Stream<ConnectEvent> get onConnected =>  this.socket.onConnecting;
  Stream<ConnectEvent> get onDisconnected =>  this.socket.onDisconnecting;
}