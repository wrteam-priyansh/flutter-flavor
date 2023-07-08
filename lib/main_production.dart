import 'package:flavour_demo/app/app.dart';
import 'package:flavour_demo/app/appConfig.dart';
import 'package:flutter/material.dart';

void main() async {
  AppConfig appConfig = AppConfig();
  appConfig.setFlavor = Flavor.production;
  appConfig.setBaseurl = "Production url";
  runApp(await initializeApp(appConfig: appConfig));
}
