part of dart_force_server_lib;

/**
 * This class makes it possible to easily serve files to a client.
 *
 */
class Serveable {

  WebApplication _basicServer;
  
  Stream<HttpRequest> serve(name) {
    return _basicServer.serve(name);
  }
  
  void serveFile(HttpRequest request, String root, String fileName) {
    _basicServer.serveFile(request, root, fileName);
  }

}