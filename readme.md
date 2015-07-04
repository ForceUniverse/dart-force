![VERSION!](https://img.shields.io/pub/v/force.svg) [![Build Status](https://drone.io/github.com/ForceUniverse/dart-force/status.png)](https://drone.io/github.com/ForceUniverse/dart-force/latest)

### Dart Force Framework ###

![LOGO!](https://raw.github.com/ForceUniverse/dart-force/master/resources/dart_force_logo.jpg)

A realtime web framework for dart.

With this framework communication between client and server becomes easy, without any boilerplate code.

#### Introduction ####

Dart Force is a Realtime web framework for [Dart](http://www.dartlang.org). We will make it easy for you to create realtime applications with it in [Dart](http://www.dartlang.org), like a chat, interactive dashboard, multiplayer games, ...

#### How does it work? ####

##### Serverside #####

First of all you need a server to handle incoming messages and dispatch or handle this messages correctly.

```dart
import "package:force/force_serverside.dart";

ForceServer fs = new ForceServer();

main() async{
  fs.server.use("/", (req, model) => "dartforcetodo");
  await fs.start();
  
  fs.on("add", (vme, sender) {
     fs.send("update", vme.json);
  });
  
}
```

##### Clientside #####

The client can listen to messages:

```dart
ForceClient fc;
void main() {
  fc = new ForceClient();
  fc.connect();
  
  fc.onConnected.listen((e) {
    fc.on("update", (fme, sender) {
      querySelector("#list").appendHtml("<div>${fme.json["todo"]}</div>");
    });
  });
}
```

You can also send messages:
```dart
InputElement input = querySelector("#input");
var data = {"todo": input.value};
fc.send("add", data);
```

It is a little bit inspired by [socket.io](http://socket.io) for the communication flow.

##### Dart Force mvc access (routing) #####

You have access to the force mvc webserver if you do the following:
```dart
  forceServer.server.on(url, controllerHandler, method: 'GET');
```

or just create a controller class. For more info go to the project page of [force mvc](https://github.com/ForceUniverse/dart-force/wiki/ForceMVC%3A-Serverside-routing)

#### Shelf integration ####

You can very easily use the power of Force into the shelf stack by using shelf_web_socket package and then use the following code, so that force can interpret the websocket stream of shelf.

```dart
   Force force = new Force();
   var _handlerws = webSocketHandler((webSocket) => force.handle(new StreamSocket(webSocket)));
```

More info on the [wiki page](https://github.com/ForceUniverse/dart-force/wiki/Shelf)

#### Quick starter guide ####

This guide can help you to get you started! [Getting started](https://github.com/ForceUniverse/dart-force/wiki/Getting-started)

* Reference
    * [Long polling](https://github.com/ForceUniverse/dart-force/wiki/Long-polling)
    * [Communication flow](https://github.com/ForceUniverse/dart-force/wiki/Communication-flow)
    * [Profile management](https://github.com/ForceUniverse/dart-force/wiki/Profile-management)
    * [Annotations](https://github.com/ForceUniverse/dart-force/wiki/Annotations)
    * [ForceMVC: Serverside routing, similar too spring mvc](https://github.com/ForceUniverse/dart-force/wiki/ForceMVC%3A-Serverside-routing)
    * [Authentication](https://github.com/ForceUniverse/dart-force/wiki/Authentication)
    * [Google AppEngine](https://github.com/ForceUniverse/dart-force/wiki/Google-AppEngine)
    * [Connectors](https://github.com/ForceUniverse/dart-force/wiki/Connectors)
    	* [Server 2 Server Communication](https://github.com/ForceUniverse/dart-force/wiki/server-2-server) 
    * [Custom protocols](https://github.com/ForceUniverse/dart-force/wiki/Custom-protocols)
    * [Clientside DB API](https://github.com/ForceUniverse/dart-force/wiki/Clientside-DB-API)
	  
Look at our wiki for more [info](https://github.com/ForceUniverse/dart-force/wiki) or this info below.

#### Examples ####

You can find a lot of examples in the force examples [organisation](https://github.com/ForceExamples)

Links to some examples that I made with this framework.

[chat](http://forcechat.herokuapp.com/) - [source code](https://github.com/ForceExamples/dart-force-chat-example)

[polymer example](http://polymerforce.herokuapp.com) - [source code](https://github.com/jorishermans/dart-force-polymer-example)

#### Development trick ####

Following the next steps will make it easier for you to develop, this allows you to adapt clientside files and immidiatly see results without doing a pub build.

	pub serve web --hostname 0.0.0.0 --port 7777 &&
	export DART_PUB_SERVE="http://localhost:7777" &&
	pub run bin/server.dart
	
#### Server 2 Server ####

It is also possible to do server 2 server communication. You can find the more info [here](https://github.com/ForceUniverse/dart-force/wiki/server-2-server)

or you can watch the [video](https://www.youtube.com/watch?v=4J33_60Bf3I) 

### Notes to Contributors ###

#### Fork Dart Force ####

If you'd like to contribute back to the core, you can [fork this repository](https://help.github.com/articles/fork-a-repo) and send us a pull request, when it is ready.

If you are new to Git or GitHub, please read [this guide](https://help.github.com/) first.

#### Twitter ####

Follow us on twitter https://twitter.com/usethedartforce

#### Google+ ####

Follow us on [google+](https://plus.google.com/111406188246677273707)

or join our [G+ Community](https://plus.google.com/u/0/communities/109050716913955926616) 

#### Screencast tutorial ####

Screencast todo tutorial about the dart force realtime functionality on [youtube](http://youtu.be/FZr75CsBNag)

#### Join our discussion group ####

[Google group](https://groups.google.com/forum/#!forum/dart-force)
