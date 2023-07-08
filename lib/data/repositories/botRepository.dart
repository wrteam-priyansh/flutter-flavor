import 'package:dio/dio.dart';
import 'package:flavour_demo/data/models/botQuery.dart';
import 'package:flavour_demo/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class BotRepository {
  Future<String> getQueryResponse({required String query}) async {
    try {
      final result = await Dio().post("https://api.openai.com/v1/completions",
          data: {
            "model": "text-davinci-003",
            "prompt": query,
            "max_tokens": 4000
          },
          options: Options(headers: {
            "Authorization":
                "Bearer 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",
            "Content-Type": "application/json",
          }));

      final jsonData = Map<String, dynamic>.from(result.data);
      print(jsonData);

      if (jsonData.containsKey("error")) {
        if (kDebugMode) {
          print(jsonData);
        }
        throw Exception("Unable to process the request now. Please try again");
      }

      final choices = ((jsonData['choices'] ?? []) as List);
      if (choices.isEmpty || (choices.first['text'] ?? "").toString().isEmpty) {
        throw Exception("Unable to process the request now. Please try again");
      }
      return choices.first['text'].toString();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<BotQuery>> loadBotConversation() async {
    final box = Hive.box(botConversationBoxKey);
    final keys = box.keys.toList();
    List<BotQuery> conversation = [];

    for (var key in keys) {
      conversation.add(BotQuery.fromJson(Map.from(box.get(key) ?? {})));
    }

    conversation
        .sort((first, second) => second.createdAt.compareTo(first.createdAt));

    //TODO: Update here the date
    return conversation;
  }

  Future<void> addBotConversation({required BotQuery botQuery}) async {
    await Hive.box(botConversationBoxKey)
        .put(botQuery.createdAt.toString(), botQuery.toJson());
  }
}
