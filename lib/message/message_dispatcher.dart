part of dart_force_common_lib;

class ForceMessageDispatcher implements ProtocolDispatch<ForceMessagePackage> {
  
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
  
  void dispatch(List<ForceMessagePackage> fmes) {
    for (var fme in fmes) {
      this.onMessageDispatch(fme);
    }
  }
  
  void onMessageDispatch(ForceMessagePackage fme) {
    var key = fme.request;
    
    for (MessageReceiver messageReceiver in beforeMapping) {
      _executeMessageReceiver(fme, messageReceiver);
    }
    if (fme.messageType.type == ForceMessageType.NORMAL) {
      _executeMessageReceiver(fme, mapping[key]);
    } else if (fme.messageType.type == ForceMessageType.BROADCAST) {
      sendable.send(fme.request, fme.json);  
      _executeMessageReceiver(fme, mapping[key]);
    } else {
      // DIRECTLY SEND THIS TO THE CORRECT CLIENT
      if (fme.messageType.type == ForceMessageType.ID) {
        sendable.sendTo(fme.messageType.id, fme.request, fme.json);
      }
      if (fme.messageType.type == ForceMessageType.PROFILE) {
        sendable.sendToProfile(fme.messageType.key, fme.messageType.value, fme.request, fme.json);
      }
      
    }
  }
  
  void _executeMessageReceiver(ForceMessagePackage vme, MessageReceiver messageReceiver) {
    if (messageReceiver!=null) {
      messageReceiver(vme, new Sender(sendable, vme.wsId));
    }
  }
}