import 'dart:html';
import 'package:force/force_browser.dart';

ForceClient fc;

main() async {
  fc = new ForceClient();
  fc.connect();
  
  await fc.onConnected;
  
  querySelector("#input").onKeyPress.listen(handleKeyEvent); 
  
  querySelector("#btn")
        ..text = "GO"
        ..onClick.listen(broadcast);
    
    fc.on("update", (fme, sender) {
      querySelector("#list").appendHtml("<div>${fme.json["todo"]}</div>");
    });
}

void handleKeyEvent(KeyboardEvent event) {
  KeyEvent keyEvent = new KeyEvent.wrap(event);
  if (keyEvent.keyCode == KeyCode.ENTER) {
      handleInput();       
  }   
}

void  broadcast(MouseEvent event) {
    handleInput();
}

void handleInput() {
  InputElement input = querySelector("#input");
    
  fc.send("add", {"todo": input.value});
    
  input.value = "";
}