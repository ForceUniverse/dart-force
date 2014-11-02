library dart_force_todo_server2;

import "package:force/force_serverside.dart";

import "dart:async";
import "dart:math";

import 'package:logging/logging.dart' show Logger, Level, LogRecord;

void main() {
  
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord rec) {
          if (rec.level >= Level.SEVERE) {
            var stack = rec.stackTrace != null ? rec.stackTrace : "";
            print('${rec.level.name}: ${rec.time}: ${rec.message} - ${rec.error} $stack');
          } else {
            print('${rec.level.name}: ${rec.time}: ${rec.message}');
          }
        });
  
  ForceClient fc = new ForceClient();
    
  fc.on("update", (fme, sender) {
      print("todo: ${fme.json["todo"]}");
  });
  
  fc.connect().then((_) {
     var data = {"todo": "server communication"};
     fc.send("add", data);
     
     var data2 = {"todo": "server communication 2 ..."};
     fc.send("add", data2);
  });
  
//  const TIMEOUT = const Duration(seconds: 3);
//    var number = 0;
//
//    new Timer.periodic(TIMEOUT, (Timer t) {
//      var rng = new Random();
//      number=rng.nextInt(250);
//      
//      print("send a number to the clients $number");
//      
//      var data = { "count" : "$number"};
//      force.send("add", data);
//    });
  
  
}