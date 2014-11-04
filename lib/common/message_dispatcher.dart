part of dart_force_common_lib;

class ForceMessageDispatcher {
  
  Sender sender;
  
  List<MessageReceiver> beforeMapping = new List<MessageReceiver>();
  Map<String, MessageReceiver> mapping = new Map<String, MessageReceiver>();
  
  ForceMessageDispatcher(this.sender);
  
  void before(MessageReceiver messageController) {
    beforeMapping.add(messageController);
  }
  
  void register(String request, MessageReceiver messageController) {
    mapping[request] = messageController;
  }
  
  void onMessagesDispatch(List<ForceMessageEvent> fmes) {
    for (var fme in fmes) {
      this.onMessageDispatch(fme);
    }
  }
  
  void onMessageDispatch(ForceMessageEvent fme) {
    var key = fme.request;
    
    for (MessageReceiver messageReceiver in beforeMapping) {
      _executeMessageReceiver(fme, messageReceiver);
    }
    if (fme.messageType.type == ForceMessageType.NORMAL) {
      _executeMessageReceiver(fme, mapping[key]);
    } else if (fme.messageType.type == ForceMessageType.BROADCAST) {
      sender.send(fme.request, fme.json);  
      _executeMessageReceiver(fme, mapping[key]);
    } else {
      // DIRECTLY SEND THIS TO THE CORRECT CLIENT
      if (fme.messageType.type == ForceMessageType.ID) {
        sender.sendTo(fme.messageType.id, fme.request, fme.json);
      }
      if (fme.messageType.type == ForceMessageType.PROFILE) {
        sender.sendToProfile(fme.messageType.key, fme.messageType.value, fme.request, fme.json);
      }
      
    }
  }
  
  void _executeMessageReceiver(ForceMessageEvent vme, MessageReceiver messageReceiver) {
    if (messageReceiver!=null) {
      messageReceiver(vme, sender);
    }
  }
}