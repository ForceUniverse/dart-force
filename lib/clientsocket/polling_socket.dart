part of dart_force_client_lib;

class PollingSocket extends AbstractSocket {
  static const Duration RECONNECT_DELAY = const Duration(milliseconds: 2000);
  
  String _url;
  bool _alreadyConnected = false;
  
  String _uuid;
  
  PollingSocket(this._url) {
    _connectController = new StreamController<ForceConnectEvent>();
    _messageController = new StreamController<MessageEvent>();
    
    _uuid = new Uuid().v4();
    print('polling socket is created');
  }
  
  void connect() {
    new Timer(RECONNECT_DELAY, polling);
  }
  
  void polling() {
    print('polling to ... http://$_url/polling?pid=$_uuid');
    HttpRequest.getString('http://$_url/polling?pid=$_uuid').then(processString);
  }
  
  void processString(String values) {
    print('process return from polling ...$values');
    var messages = JSON.decode(values);
    if (!_alreadyConnected) {
      _connectController.add(new ForceConnectEvent("connected"));
      _alreadyConnected = true;
    }
    if (messages!=null) {
      for (var value in messages) {
        var encodedValue = JSON.encode(value);
        _messageController.add(new MessageEvent("polling", data: encodedValue));
      }
    }
    new Timer(RECONNECT_DELAY, polling);
  }
  
  String _encodeMap(Map data) {
    return data.keys.map((k) {
      return '${Uri.encodeComponent(k)}=${Uri.encodeComponent(data[k])}';
    }).join('&');
  }
  
  void send(data) {
    // var encodedData = _encodeMap(data);
    var pacakge = JSON.encode({
                   "pid" : _uuid,
                   "data" : data
    });
    print('sending data to the post http://$_url/polling');
    var httpRequest = new HttpRequest();
    httpRequest.open('POST', 'http://$_url/polling');
    httpRequest.setRequestHeader('Content-type', 
    'application/x-www-form-urlencoded');
    httpRequest.onLoadEnd.listen((e) => loadEnd(httpRequest));
    httpRequest.send(pacakge);
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