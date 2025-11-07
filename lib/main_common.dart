import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setupApp() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // TODO(jovic): Implement app initialization per flavor
}
