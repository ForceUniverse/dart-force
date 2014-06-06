[![Build Status](https://drone.io/github.com/jorishermans/dart-force/status.png)](https://drone.io/github.com/jorishermans/dart-force/latest)

### Dart Force Framework ###

![LOGO!](https://raw.github.com/jorishermans/dart-force/master/resources/dart_force_logo.jpg)

A realtime web framework for dart.

With this framework communication between client and server becomes easy, without any boilerplate code.

#### Walkthrough ####

##### Client side #####

Import the client side library for dart force.

	import 'package:force/force_browser.dart';

First create a client.
	 
	 ForceClient forceClient = new ForceClient();
	 forceClient.connect();
	 
Listen on the connection, when it is established.

	 forceClient.onConnected.listen((e) {
	      
	 });
	 
Listen on the connection, when it is been broken.

	 forceClient.onDisconnected.listen((e) {
	      
	 });

Listen on messages with the request of text.

	 forceClient.on("text", (e, sender) {
	      ...
	 });

You can also send messages to the server.

	forceClient.send('text', request);


##### Server Side #####

Import Serverside code for dart force.

	import 'package:force/force_serverside.dart';

Instantiate a forceserver.

	ForceServer fs = new ForceServer( port: 9223, startPage: 'start.html' );
	
Other optional properties that are possible on ForceServer:

wsPath: is the websocket path of the server
host: is the domain name of your application, by default to localhost
port: is the adres port of the application
buildPath: is the build path of the application by default this is ../build/web/
startPage: the startpage of the application, the html name that the app needs to use as default root page
staticDir: is the public directory where you can put your stylesheets and images

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
	
#### Other features ####

##### Profile info & client to client communication #####

Adding profile data on a connection, this will make it easy to send a message to a certain profile group or sending messages to an individual, without knowing his websocket id.

On the client you can set the current browser user his profile data as follow.

	 var profileInfo = { 'name' : chatName};
     forceClient.initProfileInfo(profileInfo);

On the server you can send something to a profile or a profile group by the following method in sendable.

	sendable.sendToProfile('name', name, 'private', message);
	
You can also listen to profileChanges by using the following method on the forceServer.

	fs.onProfileChanged().listen((e) => print("$e"));
	
Now you can send directly from the client to another client, the server notice the message type and forward it directly to the corresponding client. 
No coding on server required todo this!

Just add the following code in your client side code.

	forceClient.sendToProfile(key, value, request, data);

##### Long polling #####

You can easily use long polling as follow!

	forceClient = new ForceClient(usePolling: true, heartbeat: 200);
	
##### Serverside Classes with Receiver method annotations #####

On the server you can use @Receiver on a method to define that this is a receiver method.
It is the same as forceServer.on("play", (e, sendable) { 

	@Receiver("play") 
  	void onGamePlay(ForceMessageEvent vme, Sender sender) {

You can register this class with the register method of a ForceServer object.

	forceServer.register(new GameReceiver());
	
You can also annotate a class with the @Receivable annotation, so the system can pick up this class and automatically register these classes.
	
##### Dart Force mvc access #####

You have access to the force mvc webserver if you do the following:

	forceServer.server.on(url, controllerHandler, method: 'GET');

##### Authentication #####

You can now add the annotation @Authentication() to a receiver class.

You can also do the following.

	forceServer.on("examplerequest", (e, sendable) {
	   // do something
	}, authentication: auth); 

An authentication in force is following a strategy.
You can set a strategy by extending the class SecurityStrategy.

	class SessionStrategy extends SecurityStrategy {
	  
	  bool checkAuthorization(HttpRequest req) {
	    HttpSession session = req.session;
	    return (session["user"]!=null);
	  }   
	  
	  Uri getRedirectUri(HttpRequest req) {
	    var referer = req.uri.toString();
	    return Uri.parse("/login/?referer=$referer");
	  }
	} 
	
And then add this strategy to the webserver.

	forceServer.server.strategy = new SessionStrategy();
	
When you are not authorized, the system sends the following message back:
"unauthorized" with the data you send over the system. 
So you can also listen to the message "unauthorized" in your client, then you can inform the user he need to login.

#### Logging ####

You can easily boostrap logging.

	server.setupConsoleLog();

### Api documents ###

You can find them [here](https://jorishermans.github.io/dart-force/api/index.html) 

### Notes to Contributors ###

#### Fork Dart Force ####

If you'd like to contribute back to the core, you can [fork this repository](https://help.github.com/articles/fork-a-repo) and send us a pull request, when it is ready.

If you are new to Git or GitHub, please read [this guide](https://help.github.com/) first.

#### Twitter ####

Follow us on twitter https://twitter.com/usethedartforce

#### Google+ ####

Follow us on [google+](https://plus.google.com/111406188246677273707)

#### examples ####

Links to some examples that I made with this framework.

[chat](http://forcechat.herokuapp.com/) - [source code](https://github.com/jorishermans/dart-force-chat-example)
[polymer example](http://polymerforce.herokuapp.com) - [source code](https://github.com/jorishermans/dart-force-polymer-example)