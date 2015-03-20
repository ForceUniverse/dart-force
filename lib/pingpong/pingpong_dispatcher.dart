part of dart_force_common_lib;

class PingPongDispatcher implements ProtocolDispatch<PingPongPackage> {
  
  SendablePackage sendablePackage;
  
  PingPongDispatcher(this.sendablePackage);
  
  void dispatch(PingPongPackage ppp) {
    if (ppp.state == PingPongPackage.PING) {
      sendablePackage.sendPackage(new PingPongPackage(PingPongPackage.PONG));
    }
  }
}