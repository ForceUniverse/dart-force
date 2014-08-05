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
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'normal'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    force.on(request, expectAsync((e, sendable) {
        expect(e.profile['name'], profileName);
        expect(e.json['key'], 'value');
        expect(e.json['key2'], 'value2');
    }));
    
    StreamController controller = new StreamController.broadcast();
    StreamSocket streamSocket = new StreamSocket(controller.stream);
    streamSocket.add(sendingPackage);
  });
  
  
}