part of dart_force_common_lib;

/**
 * Represents a protocol, this will be used in the communication flow and in the client db api flow
 * or you can use this class when you want to define your own protocol
 */
abstract class Protocol<T> {
  
  ProtocolDispatch<T> dispatcher;
  
  List<T> onConvert(messages, {wsId: "-"});
  
  bool shouldDispatch(data);
  
  void dispatch(data, {wsId: "-"}) {
    if (shouldDispatch(data)) {
      dispatcher.dispatch(onConvert(data, wsId: wsId)); 
    }
  }
}

abstract class ProtocolDispatch<T> {
  
  void dispatch(List<T> protocolMessages);
  
}

/**
 * It analyzes all the protocols and then dispatch it on there working half.
 */
class ProtocolDispatchers {
  
  List<Protocol> protocols = new List<Protocol>();
  
  void dispatch(data, {wsId: "-"}) {
    for (var protocol in protocols) {
      protocol.dispatch(data, wsId: wsId);
    }
  }
  
}