import 'package:test/test.dart';
import 'package:force/force_serverside.dart';
import 'package:force/test.dart';
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