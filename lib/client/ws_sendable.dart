part of dart_force_client_lib;

class ClientSendable implements Sender {
  
  Socket socket;
 
  var _profileInfo; 
  
  MessagesConstructHelper _messagesConstructHelper = new MessagesConstructHelper();
  
  void initProfileInfo(profileInfo) {
    _messagesConstructHelper.initProfileInfo(profileInfo);
    send('profileInfo', {});
  }
  
  // send it to the server
  void send(request, data) {
    this._send(_messagesConstructHelper.send(request, data));
  }
  
  // broadcast it directly to all the clients
  void broadcast(request, data) {
    this._send(_messagesConstructHelper.broadcast(request, data));
  }
  
  // send to a specific socket with an id
  void sendTo(id, request, data) {
     
     this._send(_messagesConstructHelper.sendTo(id, request, data));
  }
  
  // send to a profile with specific values
  void sendToProfile(key, value, request, data) {
    this._send(_messagesConstructHelper.sendToProfile(key, value, request, data));
  }
  
  void _send(sendingPackage) {
    if (socket != null && socket.isOpen()) {
      print('send package to the server $sendingPackage');
      socket.send(JSON.encode(sendingPackage));
    } else {
      print('WebSocket not connected, message $sendingPackage not sent');
    }
  }

}