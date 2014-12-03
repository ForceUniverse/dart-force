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
    
  dynamic send(request, data) {
     ForceMessagePackage fme = new ForceMessagePackage(request,new ForceMessageType(ForceMessageType.NORMAL), data,_profileInfo);
     return fme;
  }
      
  // broadcast it directly to all the clients
  dynamic broadcast(request, data) {
     ForceMessagePackage fme = new ForceMessagePackage(request,new ForceMessageType(ForceMessageType.BROADCAST), data,_profileInfo);
     return fme;
  }
  
  // broadcast it directly to all the clients
  dynamic subscribe(collection) {
    return _collection(ForceMessageType.SUBSCRIBE, collection, "", {});
  }
  
  // broadcast it directly to all the clients
  dynamic add(collection, key, value) {
    return _collection(ForceMessageType.ADD, collection, key, value);
  }
  
  // broadcast it directly to all the clients
  dynamic update(collection, key, value) {
    return _collection(ForceMessageType.UPDATE, collection, key, value);
  }
  
  // broadcast it directly to all the clients
  dynamic remove(collection, key) {
    return _collection(ForceMessageType.REMOVE, collection, key, {});
  }
  
  // broadcast it directly to all the clients
  dynamic set(collection, key, value) {
    return _collection(ForceMessageType.SET, collection, key, value);
  }
  
  // send to a specific socket with an id
  dynamic _collection(type, collection, request, data) {
      var sendingPackage =  {
           'request': request,
           'profile': _profileInfo,
           'type': { 'name' : type, 'collection' : collection},
           'data': data
      };
      return sendingPackage;
  }
   
  // send to a specific socket with an id
  dynamic sendTo(id, request, data) {
     ForceMessagePackage fme = new ForceMessagePackage(request,new ForceMessageType(ForceMessageType.ID), data,_profileInfo);
     fme.messageType.id = id;
     return fme;
  }
    
  // send to a profile with specific values
  dynamic sendToProfile(key, value, request, data) {
     ForceMessagePackage fme = new ForceMessagePackage(request,new ForceMessageType(ForceMessageType.PROFILE), data,_profileInfo);
     fme.messageType.key = key;
     fme.messageType.value = value;
     return fme;
  }
}