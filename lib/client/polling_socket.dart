part of dart_force_client_lib;

class PollingSocket extends AbstractSocket {
  static const Duration RECONNECT_DELAY = const Duration(milliseconds: 500);
  
  String _url;
  
  PollingSocket(this._url) {
    _connectController = new StreamController<ForceConnectEvent>();
    _messageController = new StreamController<MessageEvent>();
    
    print('polling socket is created');
  }
  
  void connect() {
    new Timer(RECONNECT_DELAY, polling);
  }
  
  void polling() {
    print('polling to ... http://$_url/polling');
    HttpRequest.getString('http://$_url/polling').then(processString);
  }
  
  void processString(String value) {
    _messageController.add(new MessageEvent("polling", data: value));
  }
  
  String _encodeMap(Map data) {
    return data.keys.map((k) {
      return '${Uri.encodeComponent(k)}=${Uri.encodeComponent(data[k])}';
    }).join('&');
  }
  
  void send(data) {
    // var encodedData = _encodeMap(data);
    print('sending data to the post http://$_url/polling');
    var httpRequest = new HttpRequest();
    httpRequest.open('POST', 'http://$_url/polling');
    httpRequest.setRequestHeader('Content-type', 
    'application/x-www-form-urlencoded');
    httpRequest.onLoadEnd.listen((e) => loadEnd(httpRequest));
    httpRequest.send(data);
  }
  
  void loadEnd(HttpRequest request) {
    if (request.status != 200) {
      print('Uh oh, there was an error of ${request.status}');
    } else {
      print('Data has been posted');
    }
  }
  
  bool isOpen() => true;
}