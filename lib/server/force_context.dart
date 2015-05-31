part of force.server;

class ForceContext {
  
  ProtocolDispatchers _protocolDispatchers;
  CargoHolder _cargoHolder;
  ForceMessageDispatcher _forceMessageDispatcher;
  CargoPackageDispatcher _cargoPackageDispatcher;
  
  Force force;
  
  ForceContext(this.force);
  
  ProtocolDispatchers protocolDispatchers() {
      if (_protocolDispatchers == null) {
        _protocolDispatchers = new ProtocolDispatchers(this.force);
        ForceMessageProtocol forceMessageProtocol = new ForceMessageProtocol(messageDispatch());
        _protocolDispatchers.addProtocol(forceMessageProtocol);
        
        // add Cargo
        ForceCargoProtocol forceCargoProtocol = new ForceCargoProtocol(cargoPacakgeDispatcher());
        _protocolDispatchers.addProtocol(forceCargoProtocol);
      }
      return _protocolDispatchers;
  } 
  
  ForceMessageDispatcher messageDispatch() {
      if (_forceMessageDispatcher == null) {
        _forceMessageDispatcher = new ForceMessageDispatcher();
      }
      return _forceMessageDispatcher;
  }
    
  CargoHolder _innerCargoHolder() {
      if (_cargoHolder == null) {
        _cargoHolder = new CargoHolderServer(this.force);
      }
      return _cargoHolder;
  }
    
  CargoPackageDispatcher cargoPacakgeDispatcher() {
      if (_cargoPackageDispatcher==null) {
          _cargoPackageDispatcher = new CargoPackageDispatcher(_innerCargoHolder());
      }
      return _cargoPackageDispatcher;
  }
}