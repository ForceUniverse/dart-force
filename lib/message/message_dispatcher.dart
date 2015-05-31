part of force.common;

typedef MessageReceiver(MessagePackage fme, Sender sender);

class ForceMessageDispatcher extends ProtocolDispatch<MessagePackage> {
  
  List<MessageReceiver> beforeMapping = new List<MessageReceiver>();
  Map<String, MessageReceiver> mapping = new Map<String, MessageReceiver>();
  
  ForceMessageDispatcher();
  
  void before(MessageReceiver messageController) {
    beforeMapping.add(messageController);
  }
  
  void register(String request, MessageReceiver messageController) {
    mapping[request] = messageController;
  }
  
  void dispatch(MessagePackage fme) {
    var key = fme.request;
    
    for (MessageReceiver messageReceiver in beforeMapping) {
      _executeMessageReceiver(fme, messageReceiver, sendable);
    }
    if (fme.messageType.type == MessageType.NORMAL) {
      _executeMessageReceiver(fme, mapping[key], sendable);
    } else if (fme.messageType.type == MessageType.BROADCAST) {
      sendable.send(fme.request, fme.json);  
      _executeMessageReceiver(fme, mapping[key], sendable);
    } else {
      // DIRECTLY SEND THIS TO THE CORRECT CLIENT
      if (fme.messageType.type == MessageType.ID) {
        sendable.sendTo(fme.messageType.id, fme.request, fme.json);
      }
      if (fme.messageType.type == MessageType.PROFILE) {
        sendable.sendToProfile(fme.messageType.key, fme.messageType.value, fme.request, fme.json);
      }
      
    }
  }
  
  void _executeMessageReceiver(MessagePackage fme, MessageReceiver messageReceiver, Sendable sendable) {
    if (messageReceiver!=null) {
      messageReceiver(fme, new Sender(sendable, fme.wsId));
    }
  }
}