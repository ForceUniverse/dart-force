part of dart_force_server_lib;

/**
 * This class makes it possible to easily serve files to a client.
 *
 */
class Serveable {

  WebServer _basicServer;
  
  Stream<HttpRequest> serve(name) {
    return _basicServer.serve(name);
  }
  
  void serveFile(String fileName, HttpRequest request) {
    _basicServer.serveFile(fileName, request);
  }

}