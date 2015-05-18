import 'package:test/test.dart';
import 'package:force/force_serverside.dart';
import 'package:cargo/cargo_base.dart';
import 'package:cargo/cargo_server.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  var collection = "posts";
  var profileName = 'chatName';
  HttpRequest req;
  
  var data = { 'key' : 'value', 'key2' : 'value2' };
  var profileInfo = {'name' : profileName};
  
  test('force cargo package test', () {  
    ForceServer fs = new ForceServer();
    Cargo cargo = new Cargo();
    fs.publish(collection, cargo);
    
    var sendingPackage = new CargoPackage(collection, new CargoAction(CargoAction.ADD), profileInfo, json: data);

    cargo.onAll((DataEvent de) {
      expect(data, de.data[0]);
    });
    
    fs.handleMessages(req, "id:bla", JSON.encode(sendingPackage));
  });
  
}