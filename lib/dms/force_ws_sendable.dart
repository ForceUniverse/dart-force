part of dart_force_client_lib;

class ClientSendable implements Sender {
  
  AbstractSocket socket;
 
  var _profileInfo;
  
  void initProfileInfo(profileInfo) {
    _profileInfo = profileInfo;
    send('profileInfo', {});
  }
  
  void send(request, data) {
    var sendingPackage =  {
        'request': request,
        'type': { 'name' : 'normal'},
        'profile': _profileInfo,
        'data': data
    };
    this._send(sendingPackage);
  }
  
  void sendTo(id, request, data) {
     var sendingPackage =  {
          'request': request,
          'profile': _profileInfo,
          'type': { 'name' : 'id', 'id' : id},
          'data': data
     };
     this._send(sendingPackage);
  }
  
  void sendToProfile(key, value, request, data) {
    var sendingPackage =  {
         'request': request,
         'profile': _profileInfo,
         'type': { 'name' : 'profile', 'key' : key, 'value' : value},
         'data': data
    };
    this._send(sendingPackage);
  }
  
  void _send(sendingPackage) {
    if (socket != null && socket.isOpen()) {
      print('send package to the server');
      socket.send(JSON.encode(sendingPackage));
    } else {
      print('WebSocket not connected, message $sendingPackage not sent');
    }
  }

}