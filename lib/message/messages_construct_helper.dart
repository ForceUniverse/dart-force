part of dart_force_common_lib;

abstract class Messenger {
  List notSendedPackages = new List();
  
  void send(sendingPackage);
  
  void offline(sendingPackage) {
      print('WebSocket not connected, message $sendingPackage not sent');
      notSendedPackages.add(sendingPackage);
  }
  
  void online();
}


class MessagesConstructHelper {
  
  var _profileInfo; 
 
  void initProfileInfo(profileInfo) {
      _profileInfo = profileInfo;
  }
    
  dynamic send(request, data) {
     MessagePackage fme = new MessagePackage(request,new MessageType(MessageType.NORMAL), data,_profileInfo);
     return fme;
  }
      
  // broadcast it directly to all the clients
  dynamic broadcast(request, data) {
     MessagePackage fme = new MessagePackage(request,new MessageType(MessageType.BROADCAST), data,_profileInfo);
     return fme;
  }
  
  // broadcast it directly to all the clients
  dynamic subscribe(collection, {params, Options options}) {
    //return _collection(ForceMessageType.SUBSCRIBE, collection, "", {});
    return new CargoPackage(collection, new CargoAction(CargoAction.SUBSCRIBE), _profileInfo, params: params, options: options);
  }
  
  // broadcast it directly to all the clients
  dynamic add(collection, key, value) {
    return new CargoPackage(collection, new CargoAction(CargoAction.ADD), _profileInfo, key: key, json: value);
  }
  
  // broadcast it directly to all the clients
  dynamic update(collection, key, value) {
    return new CargoPackage(collection, new CargoAction(CargoAction.UPDATE), _profileInfo, key: key, json: value);
  }
  
  // broadcast it directly to all the clients
  dynamic remove(collection, key) {
    return new CargoPackage(collection, new CargoAction(CargoAction.REMOVE), _profileInfo, key: key);
  }
  
  // broadcast it directly to all the clients
  dynamic set(collection, value) {
    return new CargoPackage(collection, new CargoAction(CargoAction.SET), _profileInfo, json: value);
  }
   
  // send to a specific socket with an id
  dynamic sendTo(id, request, data) {
     MessagePackage fme = new MessagePackage(request,new MessageType(MessageType.ID), data,_profileInfo);
     fme.messageType.id = id;
     return fme;
  }
    
  // send to a profile with specific values
  dynamic sendToProfile(key, value, request, data) {
     MessagePackage fme = new MessagePackage(request,new MessageType(MessageType.PROFILE), data,_profileInfo);
     fme.messageType.key = key;
     fme.messageType.value = value;
     return fme;
  }
}