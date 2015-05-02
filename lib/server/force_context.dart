part of dart_force_server_lib;

class ForceContext {
  
  ProtocolDispatchers _protocolDispatchers;
  CargoHolder _cargoHolder;
  ForceMessageDispatcher _forceMessageDispatcher;
  CargoPackageDispatcher _cargoPackageDispatcher;
  
  Force force;
  
  ForceContext(this.force);
  
  ProtocolDispatchers protocolDispatchers() {
      if (_protocolDispatchers == null) {
        _protocolDispatchers = new ProtocolDispatchers();
        ForceMessageProtocol forceMessageProtocol = new ForceMessageProtocol(messageDispatch());
        _protocolDispatchers.addProtocol(forceMessageProtocol);
        
        // add Cargo
        ForceCargoProtocol forceCargoProtocol = new ForceCargoProtocol(cargoPacakgeDispatcher());
        _protocolDispatchers.addProtocol(forceCargoProtocol);
        
        // add Ping Pong
        PingPongDispatcher pingpongDispatcher = new PingPongDispatcher(this.force);
        PingPongProtocol pingPongProtocol = new PingPongProtocol(pingpongDispatcher);
        _protocolDispatchers.addProtocol(pingPongProtocol);
      }
      return _protocolDispatchers;
  } 
  
  ForceMessageDispatcher messageDispatch() {
      if (_forceMessageDispatcher == null) {
        _forceMessageDispatcher = new ForceMessageDispatcher(this.force);
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
          _cargoPackageDispatcher = new CargoPackageDispatcher(_innerCargoHolder(), this.force);
      }
      return _cargoPackageDispatcher;
  }
}