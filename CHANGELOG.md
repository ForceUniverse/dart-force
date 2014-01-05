### Changelog ###

This file contains highlights of what changes on each version of the polymer package. We will also note important changes to the polyfill packages if they impact polymer: custom_element, html_import, observe, shadow_dom, and template_binding.

#### Pub version 0.3.0+3 ####

Added an optional parameter url to forceclient so you can set the url to another hosted force server endpoint.

#### Pub version 0.3.0+2 ####

Refactor the code so it uses a factory instead of a static method to choose the socket implementation clientside.
Fixed an small issue when sending characters through polling and receiving it again.

#### Pub version 0.3.0+1 ####

Sending the old property values in the profile changed event. So you can use the old value and look at the new value in profileInfo field.

#### Pub version 0.3.0 ####

Adding socket abstraction to the dart force framework and add also the long polling mechanism as an alternative for websockets.