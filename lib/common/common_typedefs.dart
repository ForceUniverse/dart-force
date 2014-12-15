part of dart_force_common_lib;

typedef MessageReceiver(ForceMessagePackage vme, Sender sender);

typedef bool FilterReceiver(data, params, id);

var basisFilterReceiver = (data, params, id) {
  return true;
};