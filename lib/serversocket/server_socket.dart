part of dart_force_server_lib;

 /**
 *
 * A wrapper class for the ServerSocket implementation!
 * 
 */
class ServerSocketWrapper extends StreamSocket {
  
  
  ServerSocketWrapper(Socket socket, [request]) : super(socket, socket);
  
}