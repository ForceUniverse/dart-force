### Dart Force Framework ###

A realtime web framework for dart.

With this framework communication between client and server becomes easy, without any boilerplate code.

#### Walkthrough ####

##### Client side #####

First create a client.
	 ForceClient forceClient = new ForceClient();
	 forceClient.connect();
	 
Listen on the connection, when it is established and when is been broken.

	 forceClient.onConnecting.listen((e) {
	      if (e.type=="connected") {
	        ...
	      } else if (e.type=="disconnected") {
	        ...
	      }
	 });
	 
Listen on messages with the request of text.

	 forceClient.on("text", (e, sender) {
	      ...
	 });

You can also send messages to the server.

	forceClient.send('text', request);


##### Server Side #####

Instantiate a forceserver.

	ForceServer fs = new ForceServer( port: 9223 );

Listen on messages of type text and react upon that.

	fs.on('text', (e, sendable) { 
	    var json = e.json;
	    var line = json['line'];
	    sendable.send('text', { 'line': line });
	});

You can also serve files from the server part.

	fs.start().then((_) {
	    fs.serve("/client.dart").listen((request) { 
	      fs.serveFile("../web/client.dart", request);
	    });
	});

#### TODO ####

- fallback support for legacy browser with no capability of websockets
- adding authentication support and security support
- writing tests