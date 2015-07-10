part of force.client;

// this will be used to easily transform and create, register a receiver obj.
ForceClient fc;

initForceClient(ForceClient forceClient) {
  fc = forceClient;
}

registerReceiver(String request, MessageReceiver messageReceiver) {
  if (fc==null) {
    ForceClient fc = new ForceClient();
    fc.connect();
  }

  fc.on(request, messageReceiver);
}