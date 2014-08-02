part of dart_force_server_lib;

class ForceProfileEvent {
  
  ForceProfileType type;
  String wsId;
  dynamic profileInfo;
  ForceProperty property;
  
  ForceProfileEvent(this.type, this.wsId, this.profileInfo, {property: null}) {
    this.property = property;
  } 
  
  toString() => "[$wsId] $type $profileInfo";
}

class ForceProperty {
  
  String key;
  String value;
  
  ForceProperty(this.key, this.value);
  
  toString() => "$key - $value";
}

class ForceProfileType {
  final String _type;

  const ForceProfileType(this._type);

  static const New = const ForceProfileType('New');
  static const Removed = const ForceProfileType('Removed');
  static const NewProperty = const ForceProfileType('NewProperty');
  static const ChangedProperty = const ForceProfileType('ChangedProperty');
  
  toString() => "$_type";
}