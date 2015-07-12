part of force.client;

// this will be used to easily transform and create, register a receiver obj.
ForceClient fc;

ForceClient initForceClient(ForceClient forceClient, {connect: false}) {
  if (forceClient == null) {
    forceClient = new ForceClient();
  }
  if (connect) forceClient.connect();

  fc = forceClient;

  return fc;
}

registerReceiver(String request, MessageReceiver messageReceiver) {
  if (fc == null) {
    fc = new ForceClient();
  }

  fc.onConnected.listen((e) {
    fc.on(request, messageReceiver);
  });
}