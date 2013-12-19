import 'package:unittest/unittest.dart';
import 'package:force/force_serverside.dart';
import 'dart:convert';

void main() {
  print("Hello, World!"); 
  
  test('force basic messageDispatcher test', () {
    ForceServer fs = new ForceServer();
    var request = "req:";
    var profileName = 'chatName';
    
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'normal'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.on(request, expectAsync2((e, sendable) {
        expect(e.profile['name'], profileName);
        expect(e.json['key'], 'value');
        expect(e.json['key2'], 'value2');
    }));

    
    fs.handleMessages("id:bla", JSON.encode(sendingPackage));
  });
  
}