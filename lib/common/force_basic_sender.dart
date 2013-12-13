part of dart_force_common_lib;

abstract class Sender {

  void send(request, data);
  
  void sendTo(id, request, data);

}