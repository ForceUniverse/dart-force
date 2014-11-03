library dart_force_todo_server2;

import "package:force/force_serverside.dart";

import "dart:async";
import "dart:io";

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
  
  var pathTo = Platform.script.resolve("../store/").toFilePath();
  var uriKey = new Uri.file(pathTo).resolve("todo.txt");
  File file = new File(uriKey.toFilePath());
  Directory dir = new Directory(pathTo);
  
  fc.connect().then((_) {
     // readlines    
     dir.watch().listen((FileSystemEvent fse) {
       if (fse.type == FileSystemEvent.MODIFY && !fse.isDirectory) {
         file.readAsLines().then((List<String> lines) {
           for (var line in lines) {
              var data = {"todo": line};
              fc.send("add", data);
           }
         });
       }
     });
  });
  
}