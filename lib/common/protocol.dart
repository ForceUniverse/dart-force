part of force.common;

/**
 * Represents a protocol, this will be used in the communication flow and in the client db api flow
 * or you can use this class when you want to define your own protocol
 */
abstract class Protocol<T> {
  
  ProtocolDispatch<T> dispatcher;
  
  // sendable add this to dispatcher
  void set sendable(Sendable sendable) {
      dispatcher.sendable = sendable;
  }
  
  T onConvert(data, {wsId: "-"});
  
  bool shouldDispatch(data);
  
  List<T> convertPackages(data, {wsId: "-"}) {
    List<T> packages = new List<T>();
    List<String> data_lines = removeEmptyLines(data.split("\n"));
    for (var line in data_lines) {
         packages.add(onConvert(line, wsId: wsId));
    }
    return packages;
  }
  
  void dispatchRaw(data, {wsId: "-"}) {
    if (shouldDispatch(data)) {
      List<String> data_lines = removeEmptyLines(data.split("\n"));
      for (var line in data_lines) {
           dispatcher.dispatch(onConvert(line, wsId: wsId));
      }
    }
  }
  
  void dispatch(data) {
    if (data is T) {
      dispatcher.dispatch(data);
    }
  }
  
  List<String> removeEmptyLines(List<String> lines) {
      List<String> notEmptyLines = new List<String>();
      for (String line in lines) {
        if (!line.trim().isEmpty) {
          notEmptyLines.add(line);
        }
      }
      return notEmptyLines;
    }
}

/**
 * It dispatches the protocol and handles the protocol by doing something with his commands.
 */
abstract class ProtocolDispatch<T> {
  
  Sendable sendable;
  
  void dispatch(T protocolMessages);
  
}

/**
 * It analyzes all the protocols and then dispatch it on there working half.
 */
class ProtocolDispatchers {
  
  Sendable sendable;
  
  ProtocolDispatchers(this.sendable);
  
  List<Protocol> _protocols = new List<Protocol>();
  
  List convertPackages(data, {wsId: "-"}) {
    List packages = new List();
    for (var protocol in _protocols) {
         packages.addAll(protocol.convertPackages(data, wsId: wsId));
    }
    return packages;
  }
  
  void dispatch_raw(data, {wsId: "-"}) {
      for (var protocol in _protocols) {
        protocol.dispatchRaw(data, wsId: wsId);
      }
  }
  
  void dispatch(data) {
    for (var protocol in _protocols) {
      protocol.dispatch(data);
    }
  }
  
  void addProtocol(Protocol protocol) {
      protocol.sendable = sendable;
      _protocols.add(protocol);
  }
  
}