### Changelog ###

This file contains highlights of what changes on each version of the force package.

#### Pub version 0.6.3 ####

- add onChange listener on viewCollection
- change logic of keep alives to native keep alive implementation of a websocket

#### Pub version 0.6.2+2 ####

- add some logging about the keep alive

#### Pub version 0.6.2 & 0.6.2+1 ####

- keep a state of message when the client is offline, when it is back online we send these messages to the server
- add a ping / pong protocol 
- add a keep alive timer, that send every x seconds ping signals to the clients

#### Pub version 0.6.1 ####

- add options possibility of cargo into the db client api of force
- easier transform your clientside objects with serialize function
- upgrade to forcemvc 0.7.0 and wired 0.4.3

#### Pub version 0.6.0 ####

- designing clientside db api
- ForceClient: BC BREAK - port should be int instead of String 
- adding protocols wiring into force, having 2 clean api's next to eachother, db & communication api.
- improvements on forceclient

#### Pub version 0.5.7 ####

- adapting the start method so it is compliant with the latest ForceMVC release!
Future start({FallbackStart fallback})

#### Pub version 0.5.6+1 ####

- exporting underlying packages!

#### Pub version 0.5.6 ####

- Add 'reply' method to sender
- It works in IE9
- Upgrade to the latest ForceMVC implementations

#### Pub version 0.5.5 ####

- Server to server communication, based upon ServerSockets
- Introducing connectors

#### Pub version 0.5.4 ####

- Prepare code for use on appengine

#### Pub version 0.5.3 ####

- Add new annotation @ClosedConnection and event stream for closedConnection
- Add more documentation in the code

#### Pub version 0.5.2 ####

fix dependencies on 'wired'

#### Pub version 0.5.1 & pub version 0.5.1+1 ####

introduce @NewConnection
send a message 'ack' to the new client on connection

#### Pub version 0.5.0+1 ####

Improve internal working.

#### Pub version 0.5.0 ####

Remove parentheses from annotations.
Upgrade to latest forcemvc version (0.5.0+1).
Expanding functionality for authentication with roles, like in forcemvc.
Adding broadcast functionality

#### Pub version 0.4.2+1 ####

Moving this framework to an organisation repo in github

#### Pub version 0.4.2 ####

When a new Socket is been created a new SocketEvent will be added.

#### Pub version 0.4.1+1 ####

Small changes in the Force class, renaming of the handle method.

#### Pub version 0.4.1 ####

Making the force logic abstract, independent of the serverside http logic.

#### Pub version 0.4.0+2 ####

Adding more tests for polling implementation, small improvements to the polling implementation.

#### Pub version 0.4.0 & 0.4.0+1 ####

Make it possible to add @Autowired and @Value into the classes with @Receivable annotations.

#### Pub version 0.3.7 ####

Making the setup of a project easier by creating a logging function.

#### Pub version 0.3.6 ####

Add authentication rules into the framework.

#### Pub version 0.3.5 ####

New structure! Look at the examples.

#### Pub version 0.3.4 ####

Add host and port parameters to force client.

#### Pub version 0.3.3+10 ####

Update dependency forcemvc.

#### Pub version 0.3.3+9 ####

Improve the working of the polling mechanics into the right direction.

#### Pub version 0.3.3+8 ####

Updating uuid package dependencies

#### Pub version 0.3.3+7 ####

Adding option for static folder of force mvc, staticDir.

#### Pub version 0.3.3+6 ####

Updating dependencies.

#### Pub version 0.3.3+5 ####

Solving issue with startpage rendering!

#### Pub version 0.3.3+4 ####

Updated this buildPath: '../build/web' to get it working in Dart 1.2

#### Pub version 0.3.3+2 & 0.3.3+3 ####

Updating dependencies.

#### Pub version 0.3.3+1 ####

Changing force_serveable with serve(name) with typing it with String.

#### Pub version 0.3.3 ####

Introducing @Receivable so you can annotate a class that has receiver methods.

#### Pub version 0.3.2+4 ####

Updating dependencies and force mirrors code.

#### Pub version 0.3.2+2 ####

Solving the initialization of the client socket.

#### Pub version 0.3.2 ####

Solving issue #12 and more toolable way to handle connecting. 
So now you need to implement onConnected and onDisconnected.

#### Pub version 0.3.1+3 ####

You have access to the webserver through server property of the force server implementation.

#### Pub version 0.3.1+2 ####

Update to the new force mvc package, update polling server code.

#### Pub version 0.3.1+1 ####

Iterate over all the annotations at a method until you found the Receiver annotation.

#### Pub version 0.3.1 ####

Extract webServer code and put it into forcemvc package 

#### Pub version 0.3.0+5 & 0.3.0+6 ####

Some small changes in logging and an update to the documentation.

#### Pub version 0.3.0+4 ####

Adding a generateId method to the forceclient class. So you can use this unique id in the client to start something, for example a gamesession!

#### Pub version 0.3.0+3 ####

Added an optional parameter url to forceclient so you can set the url to another hosted force server endpoint.
Added an optional parameter heartbeat, to specify in milliseconds the heartbeat duration.

#### Pub version 0.3.0+2 ####

Refactor the code so it uses a factory instead of a static method to choose the socket implementation clientside.
Fixed an small issue when sending characters through polling and receiving it again.

#### Pub version 0.3.0+1 ####

Sending the old property values in the profile changed event. So you can use the old value and look at the new value in profileInfo field.

#### Pub version 0.3.0 ####

Adding socket abstraction to the dart force framework and add also the long polling mechanism as an alternative for websockets.