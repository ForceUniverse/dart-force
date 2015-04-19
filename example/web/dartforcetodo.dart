import 'dart:html';
import 'package:force/force_browser.dart';

ForceClient fc;

main() async {
  fc = new ForceClient();
  fc.connect();
  
  await fc.onConnected;
  
  querySelector("#btn")
        ..text = "GO"
        ..onClick.listen(broadcast);
    
    fc.on("update", (fme, sender) {
      querySelector("#list").appendHtml("<div>${fme.json["todo"]}</div>");
    });
}

void  broadcast(MouseEvent event) {
  InputElement input = querySelector("#input");
  
  var data = {"todo": input.value};
  
  fc.send("add", data);
  
  input.value = "";
}
