part of dart_force_common_lib;

class ForceClientContext {
  
  ProtocolDispatchers protocolDispatchers = new ProtocolDispatchers();
  CargoHolder _cargoHolder;
  ForceMessageDispatcher _forceMessageDispatcher;
  ForceMessageProtocol _forceMessageProtocol;
  
  ClientSendable clientSendable;
  
  ForceClientContext(this.clientSendable) {
    _setupProtocols();
  }
  
  void _setupProtocols() {
      _cargoHolder = new CargoHolderClient(this.clientSendable);
      _forceMessageDispatcher = new ForceMessageDispatcher(this.clientSendable);
      _forceMessageProtocol = new ForceMessageProtocol(_forceMessageDispatcher);
      protocolDispatchers.protocols.add(_forceMessageProtocol);
      // add Cargo
      CargoPackageDispatcher cargoPacakgeDispatcher = new CargoPackageDispatcher(_cargoHolder, this.clientSendable);
      ForceCargoProtocol forceCargoProtocol = new ForceCargoProtocol(cargoPacakgeDispatcher);
      protocolDispatchers.protocols.add(forceCargoProtocol);
      // add Ping Pong
      PingPongDispatcher pingpongDispatcher = new PingPongDispatcher(this.clientSendable);
      PingPongProtocol pingPongProtocol = new PingPongProtocol(pingpongDispatcher);
      protocolDispatchers.protocols.add(pingPongProtocol);
  }
    
  Stream<MessagePackage> get onMessage => _forceMessageProtocol.onMessage;
    
  ViewCollection register(String collection, CargoBase cargo, {Map params, Options options, deserializeData deserialize}) {
      CargoBase cargoWithCollection = cargo.instanceWithCollection(collection);
      _cargoHolder.publish(collection, cargoWithCollection);
      this.clientSendable.subscribe(collection, params: params, options: options);
      
      return new ViewCollection(collection, cargoWithCollection, options, this.clientSendable, deserialize: deserialize);
  }
    
  void on(String request, MessageReceiver forceMessageController) {
      _forceMessageDispatcher.register(request, forceMessageController);
  }
  
}