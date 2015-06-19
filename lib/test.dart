library force.test;

import 'package:force/force_serverside.dart';
import 'dart:async';

/// A Testing helper class to construct everything you need to test end2end
class TestForce {
    TwoWaySocket _twoWaySocket = new TwoWaySocket();
    BaseForceClient forceClient;    
  
    TestForce(Force force) {
        forceClient = new TestForceClient(_twoWaySocket.clientSocket);
        force.handle(_twoWaySocket.serverSocket);
    }
}

/// Test interface for ForceClient 
class TestForceClient extends BaseForceClient with ClientSendable {
    ForceSocket socket;
    
    TestForceClient(this.socket) {
      clientContext = new ForceClientContext(this);  
      
      this.messenger = new ServerMessenger(socket);
    }
    
    void connect() {
       socket.onMessage.listen((e) {
         clientContext.protocolDispatchers.dispatch_raw(e.data);
       });
    }
  
}

/// Two way socket implementation, to mock the connection between to sockets 
class TwoWaySocket {
  
  ForceSocket clientSocket;
  ForceSocket serverSocket;
  
  TwoWaySocket() {
    StreamController clientStream = new StreamController.broadcast();
    StreamController serverStream = new StreamController.broadcast();
    
    serverSocket = new StreamSocket.fromStreamAndSink(serverStream.stream, clientStream);
    clientSocket = new StreamSocket.fromStreamAndSink(clientStream.stream, serverStream);
    
  }
  
}