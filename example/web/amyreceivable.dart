library receivables;

import 'dart:html';
import 'package:force/force_browser.dart';

@Receivable
class MyReceivable {

  @Receiver("update")
  void updateHtml(MessagePackage fme, Sender sender) => querySelector("#list").appendHtml("<div>${fme.json["todo"]}</div>");

}