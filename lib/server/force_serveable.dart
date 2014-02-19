part of dart_force_server_lib;

class Serveable {

  WebServer _basicServer;
  
  Stream<HttpRequest> serve(String name) {
    return _basicServer.router.serve(name);
  }
  
  Stream<HttpRequest> serveByPattern(Pattern name) {
    return _basicServer.router.serve(name);
  }
  
  void serveFile(String fileName, HttpRequest request) {
    Uri fileUri = Platform.script.resolve(fileName);
    _basicServer.virDir.serveFile(new File(fileUri.toFilePath()), request);
  }

}