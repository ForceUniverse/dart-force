part of dart_force_common_lib;

class ClientSendable implements Sendable, DataChangeable {
  
  Messenger messenger;
 
  var _profileInfo; 
  
  MessagesConstructHelper _messagesConstructHelper = new MessagesConstructHelper();
  
  void initProfileInfo(profileInfo) {
    _messagesConstructHelper.initProfileInfo(profileInfo);
    send('profileInfo', {});
  }
  
  // send it to the server
  void send(request, data) {
    this.sendPackage(_messagesConstructHelper.send(request, data));
  }
  
  // broadcast it directly to all the clients
  void broadcast(request, data) {
    this.sendPackage(_messagesConstructHelper.broadcast(request, data));
  }
  
  // send to a specific socket with an id
  void sendTo(id, request, data) {
     this.sendPackage(_messagesConstructHelper.sendTo(id, request, data));
  }
  
  // send to a profile with specific values
  void sendToProfile(key, value, request, data) {
    this.sendPackage(_messagesConstructHelper.sendToProfile(key, value, request, data));
  }
  
  // DB SENDABLE METHODS
  void subscribe(collection, {params, Options options}) {
    this.sendPackage(_messagesConstructHelper.subscribe(collection, params: params, options: options));
  }
  
  void add(collection, key, value, {id}) {
    this.sendPackage(_messagesConstructHelper.add(collection, key, value));
  }
  
  void update(collection, key, value, {id}) {
      this.sendPackage(_messagesConstructHelper.update(collection, key, value));
  }
  
  void remove(collection, key, {id}) {
      this.sendPackage(_messagesConstructHelper.remove(collection, key));
  }
  
  void set(collection, value, {id}) {
      this.sendPackage(_messagesConstructHelper.set(collection, value));
  }
  
  void sendPackage(sendingPackage) {
    messenger.send(sendingPackage);
  }

}