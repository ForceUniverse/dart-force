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
  
  void onMessageDispatch(ForceMessageEvent vme) {
    var key = vme.request;
    
    for (MessageReceiver messageReceiver in beforeMapping) {
      _executeMessageReceiver(vme, messageReceiver);
    }
    if (vme.messageType.type == ForceMessageType.NORMAL) {
      _executeMessageReceiver(vme, mapping[key]);
    } else if (vme.messageType.type == ForceMessageType.BROADCAST) {
      sender.send(vme.request, vme.json);  
      _executeMessageReceiver(vme, mapping[key]);
    } else {
      // DIRECTLY SEND THIS TO THE CORRECT CLIENT
      if (vme.messageType.type == ForceMessageType.ID) {
        sender.sendTo(vme.messageType.id, vme.request, vme.json);
      }
      if (vme.messageType.type == ForceMessageType.PROFILE) {
        sender.sendToProfile(vme.messageType.key, vme.messageType.value, vme.request, vme.json);
      }
      
    }
  }
  
  void _executeMessageReceiver(ForceMessageEvent vme, MessageReceiver messageReceiver) {
    if (messageReceiver!=null) {
      messageReceiver(vme, sender);
    }
  }
}