part of dart_force_server_lib;

class Serveable {

  BasicServer basicServer;
  
  Stream<HttpRequest> serve(String name) {
    return basicServer.router.serve(name);
  }
  
  void serveFile(String fileName, HttpRequest request) {
    Uri fileUri = Platform.script.resolve(fileName);
    basicServer.virDir.serveFile(new File(fileUri.toFilePath()), request);
  }

}