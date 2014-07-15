import 'package:unittest/unittest.dart';
import 'package:forcemvc/force_mvc.dart';
import 'package:force/force_serverside.dart';
import 'package:forcemvc/test.dart';

main() {  
  // First tests!  
  
  Model model = new Model();
  MockForceRequest req = new MockForceRequest();
  
  var request = "poll";
  var profileName = "jef";
  var package = {'request': request,
                 'type': { 'name' : 'normal'},
                 'profile': {'name' : profileName},
                 'data': { 'key' : 'value', 'key2' : 'value2' }};
  
  var uuid = "@pid@";
  var send_package = {
                "pid" : uuid,
                "data" : package
             };
  
  test('testing the polling server', () {
      
      PollingServer pollingServer = new PollingServer("/ws", new WebServer());
      pollingServer.onConnection.listen(expectAsync((PollingSocket socket) {
         socket.onMessage.listen(expectAsync((MessageEvent event) {
           expect(event.data["request"], request);
         }));
      }));
      
      req.postData = send_package;
      
      pollingServer.sendedData(req, model);
      pollingServer.checkMessages(req, model, uuid);
            
  });
  
 
}