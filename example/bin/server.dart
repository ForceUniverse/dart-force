library dart_force_todo;

import "package:force/force_serverside.dart";

part 'receivers/justareceiver.dart';

void main() {
  
  ForceServer fs = new ForceServer(port: 3030, 
                                   clientFiles: "../build/web/", 
                                   startPage: "dartforcetodo.html");
  
  fs.setupConsoleLog();
  
  fs.start().then((_) {
    fs.on("add", (message, sender) {
          fs.send("update", message.json);
      });
  });
  
  // add serversocket implementation into the game! server 2 server communication 
  Connector connector = new ServerSocketConnector();
  fs.addConnector(connector);
   
  connector.start();
  
}