part of dart_force_common_lib;

class ForceMessageDispatcher {
  
  Sender sender;
  Map<String, MessageReceiver> mapping = new Map<String, MessageReceiver>();
  
  ForceMessageDispatcher(this.sender);
  
  void register(String request, MessageReceiver vaderMessageController) {
    mapping[request] = vaderMessageController;
  }
  
  void onMessageDispatch(ForceMessageEvent vme) {
    var key = vme.request;
    MessageReceiver messageReceiver = mapping[key];
    if (messageReceiver!=null) {
      messageReceiver(vme, sender);
    }
  }
}