import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/flavors.dart';
import 'main_common.dart';
import 'program_genie_app.dart';

void main() {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  //TODO(jovic): Create dev environment config singleton

  setupApp();

  runApp(const ProgramGenieApp());
}
