part of dart_force_common_lib;

abstract class Messenger {
  void send(sendingPackage);
  
  void offline(sendingPackage);
}


class MessagesConstructHelper {
  
  var _profileInfo; 
 
  void initProfileInfo(profileInfo) {
      _profileInfo = profileInfo;
  }
    
  // send it to the server
  dynamic send(request, data) {
      return _prepare(ForceMessageType.NORMAL, request, data);
  }
    
  // broadcast it directly to all the clients
  dynamic broadcast(request, data) {
      return _prepare(ForceMessageType.BROADCAST, request, data);
  }
    
  // send to a specific socket with an id
  dynamic sendTo(id, request, data) {
       var sendingPackage =  {
            'request': request,
            'profile': _profileInfo,
            'type': { 'name' : ForceMessageType.ID, 'id' : id},
            'data': data
       };
       return sendingPackage;
  }
    
  // send to a profile with specific values
  dynamic sendToProfile(key, value, request, data) {
      var sendingPackage =  {
           'request': request,
           'profile': _profileInfo,
           'type': { 'name' : ForceMessageType.PROFILE, 'key' : key, 'value' : value},
           'data': data
      };
      return sendingPackage;
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
}