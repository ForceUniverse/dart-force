part of dart_force_server_lib;

class ForceClient extends Object with ClientSendable {
  ForceSocket socket;
  
  ProtocolDispatchers protocolDispatchers = new ProtocolDispatchers();
  CargoHolder _cargoHolder;
  ForceMessageDispatcher _forceMessageDispatcher;
  
  String host;
  int port;
  String url;
  
  var _profileInfo = {};
  
  ForceClient({this.host: '127.0.0.1', this.port: 4041, this.url: null}) {
    _setupProtocols();
    
    this.messenger = new ServerMessenger(socket);
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
  
  Future connect() {
    Completer completer = new Completer();
    Socket.connect(this.host, this.port).then((Socket serverSocket) {
     this.socket = new ServerSocketWrapper(serverSocket);
     this.messenger = new ServerMessenger(socket);
     
     socket.onMessage.listen((e) {
       protocolDispatchers.dispatch_raw(e.data);
     });
     
     if (!completer.isCompleted) completer.complete();
   });
   return completer.future;
  }
  
  void on(String request, MessageReceiver forceMessageController) {
      _forceMessageDispatcher.register(request, forceMessageController);
  }
  
}