library dart_force_todo_server2;

import "package:force/force_serverside.dart";


void main() {
  
  Force force = new Force();
    
  Connector clientConnector = new ServerSocketClientConnector();
  force.addConnector(clientConnector);
  
  clientConnector.start();
  
  force.on("update", (fme, sender) {
        // querySelector("#list").appendHtml("<div>${fme.json["todo"]}</div>");
    print("todo: " + fme.json["todo"]);
  });
}