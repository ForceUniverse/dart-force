part of dart_force_todo;

@Receivable
class JustAReceiver {
  
  @NewConnection
  void connection(socketId, ForceSocket socket) {
    print("new connection created for $socketId");
  }
  
  @Receiver("help")
  void help(fme, sender) {
    sender.send("options", {"values": ["a", "b", "c"]});
    
    // do more with this!
  }
  
  @ClosedConnection
  void closedConnection(socketId, ForceSocket socket) {
     print("connection closed for $socketId");
  }
}
