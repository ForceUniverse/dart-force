import 'dart:html';
import 'package:force/force_browser.dart';

import 'myreceivable.dart';

ForceClient fc;

main() async {
  // fc = initForceClient(fc, connect: true);
  fc = new ForceClient();
  fc.connect();

  querySelector("#input").onKeyPress.listen(handleKeyEvent); 
  
  querySelector("#btn")
        ..text = "GO"
        ..onClick.listen(broadcast);
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