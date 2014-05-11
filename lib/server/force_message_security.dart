part of dart_force_server_lib;

class ForceMessageSecurity {

  Map<String, bool> requestList = new Map<String, bool>();
  SecurityContextHolder securityContextHolder;
  
  ForceMessageSecurity(this.securityContextHolder);
  
  void register(String request, bool authentication) {
    requestList[request] = authentication;
  }
  
  bool checkSecurity(ForceMessageEvent fme) {
    if (requestList[fme.request]) {
      // check if you are logged in
      this.securityContextHolder.checkAuthorization(fme);
    } else {
      return true;
    }
  }
}