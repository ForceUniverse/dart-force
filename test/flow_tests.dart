import 'package:unittest/unittest.dart';
import 'package:force/force_serverside.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() {
  var request = "req:";
  var profileName = 'chatName';
  HttpRequest req;
  
  test('force basic messageDispatcher test', () {  
    Force force = new Force();

    var sendingPackage = new MessagePackage(request, new MessageType(MessageType.NORMAL), { 'key' : 'value', 'key2' : 'value2' }, {'name' : profileName});

    force.on(request, expectAsync((e, sendable) {
        expect(e.profile['name'], profileName);
        expect(e.json['key'], 'value');
        expect(e.json['key2'], 'value2');
    }));
    
    StreamSocket streamSocket = new StreamSocket.from(new StreamController.broadcast());
    streamSocket.add(JSON.encode(sendingPackage));
    
    force.handle(streamSocket);
  });
  
  
}