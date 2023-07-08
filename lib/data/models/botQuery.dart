class BotQuery {
  final String value;
  final DateTime createdAt;
  final bool byUser;

  BotQuery(
      {required this.byUser, required this.createdAt, required this.value});

  Map<String, dynamic> toJson() {
    return {
      "value": value,
      "createdAt": createdAt.toString(),
      "byUser": byUser
    };
  }

  static BotQuery fromJson(Map<String, dynamic> json) {
    return BotQuery(
        byUser: json['byUser'] ?? true,
        createdAt: json['createdAt'] == null
            ? DateTime.now()
            : DateTime.parse(json['createdAt']),
        value: json['value'] ?? "");
  }
}
