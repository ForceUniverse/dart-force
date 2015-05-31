part of force.common;

abstract class Sendable extends SendablePackage {

  void send(request, data);
  
  void sendTo(id, request, data);
  
  void sendToProfile(key, value, request, data);

}