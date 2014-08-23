part of dart_force_client_lib;

class ClientSendable implements Sender {
  
  Socket socket;
 
  var _profileInfo;
  
  void initProfileInfo(profileInfo) {
    _profileInfo = profileInfo;
    send('profileInfo', {});
  }
  
  // send it to the server
  void send(request, data) {
    this._send(_prepare(ForceMessageType.NORMAL, request, data));
  }
  
  // broadcast it directly to all the clients
  void broadcast(request, data) {
    this._send(_prepare(ForceMessageType.BROADCAST, request, data));
  }
  
  // send to a specific socket with an id
  void sendTo(id, request, data) {
     var sendingPackage =  {
          'request': request,
          'profile': _profileInfo,
          'type': { 'name' : ForceMessageType.ID, 'id' : id},
          'data': data
     };
     this._send(sendingPackage);
  }
  
  // send to a profile with specific values
  void sendToProfile(key, value, request, data) {
    var sendingPackage =  {
         'request': request,
         'profile': _profileInfo,
         'type': { 'name' : ForceMessageType.PROFILE, 'key' : key, 'value' : value},
         'data': data
    };
    this._send(sendingPackage);
  }
  
  dynamic _prepare(type, request, data) {
    var sendingPackage =  {
            'request': request,
            'type': { 'name' : type},
            'profile': _profileInfo,
            'data': data
        };
    return sendingPackage;
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