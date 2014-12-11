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
  dynamic subscribe(collection, {params}) {
    //return _collection(ForceMessageType.SUBSCRIBE, collection, "", {});
    return new ForceCargoPackage(collection, new CargoAction(CargoAction.SUBSCRIBE), _profileInfo, params: params);
  }
  
  // broadcast it directly to all the clients
  dynamic add(collection, key, value) {
    return new ForceCargoPackage(collection, new CargoAction(CargoAction.ADD), _profileInfo, key: key, data: value);
  }
  
  // broadcast it directly to all the clients
  dynamic update(collection, key, value) {
    return new ForceCargoPackage(collection, new CargoAction(CargoAction.UPDATE), _profileInfo, key: key, data: value);
  }
  
  // broadcast it directly to all the clients
  dynamic remove(collection, key) {
    return new ForceCargoPackage(collection, new CargoAction(CargoAction.REMOVE), _profileInfo, key: key);
  }
  
  // broadcast it directly to all the clients
  dynamic set(collection, key, value) {
    return new ForceCargoPackage(collection, new CargoAction(CargoAction.SET), _profileInfo, key: key);
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