part of dart_force_common_lib;

typedef MessageReceiver(MessagePackage fme, Sender sender);

class ForceMessageDispatcher implements ProtocolDispatch<MessagePackage> {
  
  Sendable sendable;
  
  List<MessageReceiver> beforeMapping = new List<MessageReceiver>();
  Map<String, MessageReceiver> mapping = new Map<String, MessageReceiver>();
  
  ForceMessageDispatcher(this.sendable);
  
  void before(MessageReceiver messageController) {
    beforeMapping.add(messageController);
  }
  
  void register(String request, MessageReceiver messageController) {
    mapping[request] = messageController;
  }
  
  void dispatch(MessagePackage fme) {
    var key = fme.request;
    
    for (MessageReceiver messageReceiver in beforeMapping) {
      _executeMessageReceiver(fme, messageReceiver);
    }
    if (fme.messageType.type == MessageType.NORMAL) {
      _executeMessageReceiver(fme, mapping[key]);
    } else if (fme.messageType.type == MessageType.BROADCAST) {
      sendable.send(fme.request, fme.json);  
      _executeMessageReceiver(fme, mapping[key]);
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
  
  void _executeMessageReceiver(MessagePackage fme, MessageReceiver messageReceiver) {
    if (messageReceiver!=null) {
      messageReceiver(fme, new Sender(sendable, fme.wsId));
    }
  }
}