part of force.server;

/**
 * This annotation can be added to a method, 
 * this method will be able to listen to messages coming in on a certain message request
 * 
 * @Receiver("add")
 * void add(vme, sender) {
 *  sender.send("update", vme.json);
 * }
 * 
 * It is the same as: 
 * fs.on("add", (vme, sender) {
      sender.send("update", vme.json);
    });
 */
class Receiver {
  
  final String request;
  const Receiver(this.request);

  String toString() => request;
  
}

/**
 * This annotation can be added to a class, this will indicate that this class can have receivable methods, 
 * that can capture messages on a certain request.
 */
const Receivable = const _Receivable();

class _Receivable {
  
  const _Receivable();
  
}

/**
 * This annotation can be used when you want to catch new connections
 * 
 * @NewConnection
 * void someNewConnection(socketId, Socket socket) {
 *   ...
 * }
 */
const NewConnection = const _NewConnection();

class _NewConnection {
  
  const _NewConnection();
  
}

/**
 * This annotation can be used when you want to catch closed connections,
 * when somebody closed his browser
 * 
 * @ClosedConnection
 * void someNewConnection(socketId, Socket socket) {
 *   ...
 * }
 */
const ClosedConnection = const _ClosedConnection();

class _ClosedConnection {
  
  const _ClosedConnection();
  
}