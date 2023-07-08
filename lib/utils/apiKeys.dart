class APIKeys {
  static String getOpenAIKey() {
    return const String.fromEnvironment('openAI', defaultValue: "");
  }
}
