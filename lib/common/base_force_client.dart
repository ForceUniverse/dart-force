part of dart_force_common_lib;

/// This is the base class of all force clients with all the acces
abstract class BaseForceClient {
 
  /// context of a client and his protocols
  ForceClientContext clientContext;
  
  /// a stream of message packages
  Stream<MessagePackage> get onMessage => clientContext.onMessage;
  
  /// register on a collection of data, to get updates and send updates back to the root database / persistance layer
  ViewCollection register(String collection, CargoBase cargo, {Map params, Options options, deserializeData deserialize}) 
                          => clientContext.register(collection, cargo, params: params, options: options, deserialize: deserialize);
  
  /// add a new protocol into force
  void addProtocol(Protocol protocol) {
    clientContext.protocolDispatchers.addProtocol(protocol);
  }
  
  /// listen to new requests for new data packages
  void on(String request, MessageReceiver forceMessageController) {
    clientContext.on(request, forceMessageController);
  }

}