part of dart_force_todo;

@Receivable
class JustAReceiver {
  
  @NewConnection
  void connection(socketId, Socket socket) {
    print("new connection created for $socketId");
  }
  
  @Receiver("help")
  void help(vme, sender) {
    // do some logic for help ...
  }
  
}