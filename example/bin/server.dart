library dart_force_todo;

import "package:force/force_serverside.dart";

void main() {
  
  ForceServer fs = new ForceServer(clientFiles: "../build/web/", startPage: "dartforcetodo.html");
  
  fs.setupConsoleLog();
  
  fs.on("add", (vme, sender) {
      fs.send("update", vme.json);
    });
  
  /*fs.onSocket.listen((SocketEvent se) {
    fs.sendTo(se.wsId, "ack", "ack");
  });*/
  
  fs.start();
  
}