enum Flavor { dev, test, production }

class AppConfig {
  late Flavor _flavor;
  late String _baseUrl;

  // next three lines makes this class a Singleton
  static final AppConfig _instance = AppConfig.internal();

  AppConfig.internal();

  factory AppConfig() => _instance;

  set setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  set setBaseurl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  Flavor get flavor => _flavor;

  String get baseUrl => _baseUrl;
}
