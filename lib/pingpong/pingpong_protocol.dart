part of dart_force_common_lib;

class PingPongProtocol extends Protocol<PingPongPackage> {
  
  StreamController<PingPongPackage> _controller;
  ProtocolDispatch<PingPongPackage> dispatcher;
  
  PingPongProtocol(this.dispatcher) {
    _controller = new StreamController<PingPongPackage>();
  }
  
  bool shouldDispatch(data) {
      // Test what is typical for this protocol
      return data.toString().contains("ping") || data.toString().contains("pong");
  }
  
  PingPongPackage onConvert(data, {wsId: "-"}) {
    PingPongPackage ppp = new PingPongPackage.fromJson(JSON.decode(data), wsId: wsId);
    return ppp;
  }
 
}