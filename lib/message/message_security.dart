part of force.server;

class ForceMessageSecurity {

  Map<String, List> requestList = new Map<String, List>();
  SecurityContextHolder securityContextHolder;
  
  ForceMessageSecurity(this.securityContextHolder);
  
  void register(String request, List<String> roles) {
    requestList[request] = roles;
  }
  
  /**
   * This method is doing security checks on top of ForceMessagePackage protocol
   */
  bool isAuthorized(HttpRequest req, package) {
    if (package is MessagePackage) {
      MessagePackage fmp = package;
      if (requestList[fmp.request] != null && requestList[fmp.request].isNotEmpty) {
        // check if you are logged in against correct credentials
        return this.securityContextHolder.checkAuthorization(req, requestList[fmp.request], data: fmp);
      }
    }
    return true;
  }
}