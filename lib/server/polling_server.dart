part of dart_force_server_lib;

class PollingServer {
  
  final Logger log = new Logger('PollingServer');
  
  Router router;
  String wsPath;
  
  PollingServer(this.router, this.wsPath) {
    print('start long polling server ... $wsPath/polling');
    router.serve('$wsPath/polling', method: "GET").listen(polling);
    router.serve('$wsPath/polling', method: "POST").listen(sendedData);
  }
  
  void polling(HttpRequest req) {
    print("get data from longpolling!");
    
    UTF8.decodeStream(req).then((content) {
      final params = Uri.splitQueryString(content);
      print(params['pid']);
    });
    
    var response = req.response;
    var dynamic = {"status" : "ok"};
    String data = JSON.encode(dynamic);
    response
    ..statusCode = 200
    ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
    ..headers.contentLength = data.length
    ..write(data)
      ..close();
  }
  
  void sendedData(HttpRequest req) {
    var response = req.response;
    var dynamic = {"status" : "ok"};
    String data = JSON.encode(dynamic);
    response
    ..statusCode = 200
    ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
    ..headers.contentLength = data.length
    ..write(data)
      ..close();
  }
  
}