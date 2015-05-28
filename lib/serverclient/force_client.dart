part of dart_force_server_lib;

class ForceClient extends BaseForceClient with ClientSendable {
  ForceSocket socket;
  
  String host;
  int port;
  String url;
  
  ForceClient({this.host: '127.0.0.1', this.port: 4041, this.url: null}) {
    clientContext = new ForceClientContext(this);  
    
    this.messenger = new ServerMessenger(socket);
  }
  
  connect() async {
     Socket serverSocket = await Socket.connect(this.host, this.port);
     this.socket = new ServerSocketWrapper(serverSocket);
     this.messenger = new ServerMessenger(socket);
     
     socket.onMessage.listen((e) {
       clientContext.protocolDispatchers.dispatch_raw(e.data);
     });   
  }
  
}