part of dart_force_server_lib;

class ForceProfileEvent {
  
  ForceProfileType type;
  String wsId;
  dynamic profileInfo;
  
  ForceProfileEvent(this.type, this.wsId, this.profileInfo); 
}

class ForceProfileType {
  final String _type;

  const ForceProfileType(this._type);

  static const New = const ForceProfileType('New');
  static const Removed = const ForceProfileType('Removed');
}