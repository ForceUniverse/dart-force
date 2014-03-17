### Changelog ###

This file contains highlights of what changes on each version of the force package.

#### Pub version 0.3.4 ####

Improve the working of the polling mechanics

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