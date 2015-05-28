import 'package:test/test.dart';
import 'package:force/force_serverside.dart';
import 'dart:convert';
import 'dart:async';

void main() {
  var request = "req:";
  var profileName = 'chatName';
  var data = { 'key' : 'value', 'key2' : 'value2' };
  
  test('force basic messageDispatcher test', () {  
    Force force = new Force();

        var sendingPackage = new MessagePackage(request, new MessageType(MessageType.NORMAL), data, {'name' : profileName});

        force.on(request, expectAsync((e, sendable) {
            expect(e.profile['name'], profileName);
            expect(e.json['key'], 'value');
            expect(e.json['key2'], 'value2');
        }));
        
        StreamSocket streamSocket = new StreamSocket.fromController(new StreamController.broadcast());
        streamSocket.add(JSON.encode(sendingPackage));
        
        force.handle(streamSocket);
  });
  
  test('sending data from client, the socket chain', () {
    Force force = new Force();
    // setup client
    TestForce tf = new TestForce(force);
    TestForceClient fc = tf.forceClient;
    fc.connect();
    
    force.on(request, expectAsync((e, sendable) {
                expect(e.profile['name'], profileName);
                expect(e.json['key'], 'value');
                expect(e.json['key2'], 'value2');
            }));
    fc.initProfileInfo({'name' : profileName});
    fc.send(request, data);
  });
  
  test('sending data from the server, the socket chain', () {
      Force force = new Force();
      // setup client
      TestForce tf = new TestForce(force);
      TestForceClient fc = tf.forceClient;
      fc.connect();
      
      fc.on(request, expectAsync((e, sendable) {
                  expect(e.json['key'], 'value');
                  expect(e.json['key2'], 'value2');
              }));
      
      force.send(request, data);
    });
  
}

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
  dynamic _client_sended_data;
  dynamic _server_sended_data;
  
  TwoWaySocket() {
    StreamController clientStream = new StreamController.broadcast();
    clientSocket = new StreamSocket.fromController(clientStream);
    
    StreamController serverStream = new StreamController.broadcast();
    serverSocket = new StreamSocket.fromController(serverStream);
    
    clientStream.stream.listen((data) {
      if (data != _server_sended_data) {
        serverStream.add(data);
        _client_sended_data = data;
      }
    });
    
    serverStream.stream.listen((data) {
      if (data != _client_sended_data) {
        clientStream.add(data);
        _server_sended_data = data;
      }
    });
  }
  
}