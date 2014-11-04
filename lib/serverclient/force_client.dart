part of dart_force_server_lib;

class ForceClient extends ForceBaseMessageSendReceiver with ClientSendable {
  ForceSocket socket;
  
  ForceMessageDispatcher _messageDispatcher;
  
  String host;
  int port;
  String url;
  
  var _profileInfo = {};
  
  ForceClient({this.host: '127.0.0.1', this.port: 4041, this.url: null}) {
    _messageDispatcher = new ForceMessageDispatcher(this);
    
    this.messenger = new ServerMessenger(socket);
  }
  
  Future connect() {
    Completer completer = new Completer();
    Socket.connect(this.host, this.port).then((Socket serverSocket) {
     this.socket = new ServerSocketWrapper(serverSocket);
     this.messenger = new ServerMessenger(socket);
     
     socket.onMessage.listen((e) {
       _messageDispatcher.onMessagesDispatch(onInnerMessage(e.data));
     });
     
     if (!completer.isCompleted) completer.complete();
   });
   return completer.future;
  }
  
  void on(String request, MessageReceiver vaderMessageController) {
    _messageDispatcher.register(request, vaderMessageController);
  }
  
}