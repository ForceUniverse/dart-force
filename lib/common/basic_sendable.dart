part of dart_force_common_lib;

abstract class Sendable {

  void send(request, data);
  
  void sendTo(id, request, data);
  
  void sendToProfile(key, value, request, data);

}