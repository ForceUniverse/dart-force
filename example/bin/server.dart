library dart_force_todo;

import "package:force/force_serverside.dart";

part 'receivers/justareceiver.dart';

void main() {
  
  ForceServer fs = new ForceServer(port: 3030, 
                                   clientFiles: "../build/web/");
  
  fs.setupConsoleLog();
  
  fs.server.use("/", (req, model) => "dartforcetodo");

  fs.start().then((_) {
    fs.on("add", (vme, sender) {
          fs.send("update", vme.json);
      });
  });
  
  // add serversocket implementation into the game! server 2 server communication 
  Connector connector = new ServerSocketConnector();
  fs.addConnector(connector);
   
  connector.start();
  
}