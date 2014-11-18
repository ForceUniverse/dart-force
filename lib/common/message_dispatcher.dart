part of dart_force_common_lib;

class ForceMessageDispatcher {
  
  Sendable sendable;
  CargoHolder cargoHolder;
  
  List<MessageReceiver> beforeMapping = new List<MessageReceiver>();
  Map<String, MessageReceiver> mapping = new Map<String, MessageReceiver>();
  
  ForceMessageDispatcher(this.sendable);
  
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
      sendable.send(fme.request, fme.json);  
      _executeMessageReceiver(fme, mapping[key]);
    } else if (fme.messageType.type == ForceMessageType.SUBSCRIBE) {
      cargoHolder.subscribe(fme.messageType.collection, fme.wsId);
    } else if (fme.messageType.type == ForceMessageType.ADD) {
      cargoHolder.add(fme.messageType.collection, fme.request, fme.json);
    } else if (fme.messageType.type == ForceMessageType.UPDATE) {
      cargoHolder.update(fme.messageType.collection, fme.request, fme.json);
    } else if (fme.messageType.type == ForceMessageType.REMOVE) {
      cargoHolder.update(fme.messageType.collection, fme.request, fme.json);
    } else if (fme.messageType.type == ForceMessageType.SET) {
      cargoHolder.set(fme.messageType.collection, fme.json);
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
  
  void _executeMessageReceiver(ForceMessageEvent vme, MessageReceiver messageReceiver) {
    if (messageReceiver!=null) {
      messageReceiver(vme, new Sender(sendable, vme.wsId));
    }
  }
}