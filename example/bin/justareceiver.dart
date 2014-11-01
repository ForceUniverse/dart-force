part of dart_force_todo;

@Receivable
class JustAReceiver {
  
  @NewConnection
  void connection(socketId, Socket socket) {
    print("new connection created for $socketId");
  }
  
  @Receiver("help")
  void help(fme, sender) {
    sender.send("options", {"values": ["a", "b", "c"]});
    
    // do more with this!
  }
  
  @ClosedConnection
  void closedConnection(socketId, Socket socket) {
     print("connection closed for $socketId");
  }
}