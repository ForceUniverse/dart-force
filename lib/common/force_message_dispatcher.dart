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
    MessageReceiver messageReceiver = mapping[key];
    if (messageReceiver!=null) {
      messageReceiver(vme, sender);
    }
  }
}