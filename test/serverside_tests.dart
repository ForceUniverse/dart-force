import 'package:unittest/unittest.dart';
import 'package:force/force_serverside.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  var request = "req:";
  var profileName = 'chatName';
  HttpRequest req;
  
  test('force basic messageDispatcher test', () {  
    ForceServer fs = new ForceServer();
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'normal'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.on(request, expectAsync((e, sendable) {
        expect(e.profile['name'], profileName);
        expect(e.json['key'], 'value');
        expect(e.json['key2'], 'value2');
    }));
    
    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
  });
  
  test('force id messageDispatcher test', () {
    ForceServer fs = new ForceServer();
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'id', 'id' : 'aefed'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.on(request, expectAsync((e, sendable) {
        print('Should not be reached'); }, count: 0));

    
    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
  });
  
  test('force profile messageDispatcher test', () {
    ForceServer fs = new ForceServer();
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'profile', 'key' : 'key', 'value' : 'value'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.on(request, expectAsync((e, sendable) {
            print('Should not be reached'); }, count: 0));

    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
  });
  
  test('force profile changing test', () {
    ForceServer fs = new ForceServer();
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'normal'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.onProfileChanged.listen(expectAsync((e) {
      String name = e.profileInfo['name'];
      
      expect(name, profileName);
    }));

    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
  });
  
  test('force new property profile changing test', () {
    ForceServer fs = new ForceServer();
    var channelName = "chnnl";
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'normal'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
    
    fs.onProfileChanged.listen(expectAsync((e) {
      if (e.type == ForceProfileType.NewProperty) {
        expect(e.property.key, 'channel');
        expect(e.property.value, channelName);
      }
    }, count: 2));
    
    sendingPackage['profile'] = {'name' : profileName, 'channel' : channelName};
    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
  });
   
  test('force changed property profile changing test', () {
    ForceServer fs = new ForceServer();
    var channelName = "chnnl";
    var sendingPackage =  {'request': request,
                           'type': { 'name' : 'normal'},
                           'profile': {'name' : profileName},
                           'data': { 'key' : 'value', 'key2' : 'value2' }};

    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
    
    fs.onProfileChanged.listen(expectAsync((e) {
      if (e.type == ForceProfileType.ChangedProperty) {
        expect(e.property.key, 'name');
        expect(e.property.value, profileName);
        expect(e.profileInfo['name'], channelName);
      }
    }, count: 2));
    
    sendingPackage['profile'] = {'name' : channelName};
    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
  });
}