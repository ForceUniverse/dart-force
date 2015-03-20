part of dart_force_common_lib;

/**
 * Represents a package that will be send through a socket
 */
abstract class SendablePackage {
  void sendPackage(package);
}

/**
 * Represents a package that will be send through a socket
 */
abstract class Package<T> {
  dynamic profile;
}