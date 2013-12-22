import 'package:unittest/unittest.dart';
import 'package:force/force_serverside.dart';
import 'dart:convert';

void main() {
  ForceServer fs = new ForceServer();
  var request = "req:";
  var profileName = 'chatName';
  
  test('force basic messageDispatcher test', () {  
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
  
  test('force id messageDispatcher test', () {
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'id', 'id' : 'aefed'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.on(request, protectAsync2((e, sendable) =>
        expect(true, isFalse, reason: 'Should not be reached')));

    
    fs.handleMessages("id:bla", JSON.encode(sendingPackage));
  });
  
  test('force profile messageDispatcher test', () {
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'profile', 'key' : 'key', 'value' : 'value'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.on(request, protectAsync2((e, sendable) =>
        expect(true, isFalse, reason: 'Should not be reached')));

    fs.handleMessages("id:bla", JSON.encode(sendingPackage));
  });
}