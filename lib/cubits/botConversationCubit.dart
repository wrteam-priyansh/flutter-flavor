import 'package:flavour_demo/data/models/botQuery.dart';
import 'package:flavour_demo/data/repositories/botRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BotConversationState {}

class BotConversationInitial extends BotConversationState {}

class BotConversationFetchInProgress extends BotConversationState {}

class BotConversationFetchSuccess extends BotConversationState {
  final List<BotQuery> conversation;

  BotConversationFetchSuccess({required this.conversation});
}

class BotConversationFetchFailure extends BotConversationState {
  final String errorMessage;

  BotConversationFetchFailure(this.errorMessage);
}

class BotConversationCubit extends Cubit<BotConversationState> {
  final BotRepository _botRepository;

  BotConversationCubit(this._botRepository) : super(BotConversationInitial());

  void loadConversation() async {
    emit(BotConversationFetchInProgress());
    try {
      emit(BotConversationFetchSuccess(
          conversation: await _botRepository.loadBotConversation()));
    } catch (e) {
      emit(BotConversationFetchFailure(e.toString()));
    }
  }

  void addConversation({required BotQuery botQuery}) {
    if (state is BotConversationFetchSuccess) {
      List<BotQuery> conversation =
          (state as BotConversationFetchSuccess).conversation;
      conversation.insert(0, botQuery);
      _botRepository.addBotConversation(botQuery: botQuery);
      emit(BotConversationFetchSuccess(conversation: conversation));
    }
  }
}
