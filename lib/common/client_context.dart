part of dart_force_common_lib;

class ForceClientContext {
  
  ProtocolDispatchers protocolDispatchers;
  CargoHolder _cargoHolder;
  ForceMessageDispatcher _forceMessageDispatcher;
  ForceMessageProtocol _forceMessageProtocol;
  
  ClientSendable clientSendable;
  
  ForceClientContext(this.clientSendable) {
    _setupProtocols(); 
  }
  
  void _setupProtocols() {
      protocolDispatchers = new ProtocolDispatchers(this.clientSendable);
      _cargoHolder = new CargoHolderClient(this.clientSendable);
      _forceMessageDispatcher = new ForceMessageDispatcher();
      _forceMessageProtocol = new ForceMessageProtocol(_forceMessageDispatcher);
      protocolDispatchers.addProtocol(_forceMessageProtocol);
      // add Cargo
      CargoPackageDispatcher cargoPacakgeDispatcher = new CargoPackageDispatcher(_cargoHolder);
      ForceCargoProtocol forceCargoProtocol = new ForceCargoProtocol(cargoPacakgeDispatcher);
      protocolDispatchers.addProtocol(forceCargoProtocol);
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