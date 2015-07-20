part of force.client;

// this will be used to easily transform and create, register a receiver obj.
ForceClient fc;

ForceClient initForceClient({connect: false}) {
  fc = new ForceClient();
  if (connect) forceClient.connect();
  return fc;
}

registerReceiver(String request, MessageReceiver messageReceiver) {
  if (fc == null) {
    fc = new ForceClient();
    fc.connect();
  }

  fc.onConnected.listen((e) {
    fc.on(request, messageReceiver);
  });
}