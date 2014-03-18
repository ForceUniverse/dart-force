part of dart_force_client_lib;

class PollingSocket extends Socket {
  Duration _heartbeat = new Duration(milliseconds: 2000);
  
  String _url;
  bool _alreadyConnected = false;
  
  String _uuid;
  
  PollingSocket(this._url, heartbeat_ms) : super._() {
    _connectController = new StreamController<ConnectEvent>();
    _disconnectController = new StreamController<ConnectEvent>();
    _messageController = new StreamController<SocketEvent>();
    
    _heartbeat = new Duration(milliseconds : heartbeat_ms);
    
    print('polling socket is created');
  }
  
  void connect() {
    HttpRequest.getString('http://$_url/uuid/').then(procces_id);
  }
  
  void procces_id(String value) {
    var json = JSON.decode(value);
    
    print(json);
    
    _uuid = json["id"];
    
    new Timer(_heartbeat, polling);
  }
  
  void polling() {
    print('polling to ... http://$_url/polling/?pid=$_uuid');
    window.alert("polling");
    HttpRequest.getString('http://$_url/polling/?pid=$_uuid').then(processString);
  }
  
  void processString(String values) {
    print('process return from polling ...$values');
    var messages = JSON.decode(values);
    if (!_alreadyConnected) {
      _connectController.add(new ConnectEvent());
      _alreadyConnected = true;
    }
    if (messages!=null) {
      for (var value in messages) {
        print('individual value -> $value');
        _messageController.add(new SocketEvent(value));
      }
    }
    new Timer(_heartbeat, polling);
  }
  
  String _encodeMap(Map data) {
    return data.keys.map((k) {
      return '${Uri.encodeComponent(k)}=${Uri.encodeComponent(data[k])}';
    }).join('&');
  }
  
  void send(data) {
    // var encodedData = _encodeMap(data);
    if (_uuid!=null) {
      var pacakge = JSON.encode({
                     "pid" : _uuid,
                     "data" : data
      });
      print('sending data to the post http://$_url/polling/');
      var httpRequest = new HttpRequest();
      httpRequest.open('POST', 'http://$_url/polling/');
      httpRequest.setRequestHeader('Content-type', 
      'application/x-www-form-urlencoded');
      httpRequest.onLoadEnd.listen((e) => loadEnd(httpRequest));
      httpRequest.send(pacakge);
    }
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