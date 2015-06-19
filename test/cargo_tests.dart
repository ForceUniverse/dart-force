import 'package:test/test.dart';
import 'package:force/force_serverside.dart';
import 'package:cargo/cargo_base.dart';
import 'package:cargo/cargo_server.dart';
import 'dart:convert';
import 'dart:io';

import 'package:force/test.dart';

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
  
  test('force cargo publish/register test', () {  
    Force force = new Force();
       // setup client
       TestForce tf = new TestForce(force);
       TestForceClient fc = tf.forceClient;
       fc.connect();
       
       Cargo cargo = new Cargo(MODE: CargoMode.MEMORY);
       force.publish("hunters", cargo, validate: (CargoPackage fcp, Sender sender) {});
       
       fc.initProfileInfo({'name' : profileName});
       
       Cargo cargo2 = new Cargo(MODE: CargoMode.MEMORY);
       fc.register("hunters", cargo2);       
    });
  
    test('force cargo publish/register test', () async {  
         Force force = new Force();
         // setup client
         TestForce tf = new TestForce(force);
         TestForceClient fc = tf.forceClient;
         fc.connect();
         
         Cargo cargo = new Cargo(MODE: CargoMode.MEMORY);
         force.publish("hunters", cargo, validate: (CargoPackage fcp, Sender sender) {
           print("nice");
         });
         
         cargo.on("value", (de) async {
           int length = await cargo.length();
           expect(length, 1);
         });
         
         // fc.initProfileInfo({'name' : profileName});
         
         Cargo cargo2 = new Cargo(MODE: CargoMode.MEMORY);
         ViewCollection vc = fc.register("hunters", cargo2);
         vc.update("value", "gogo");
         
         
    });
  
}