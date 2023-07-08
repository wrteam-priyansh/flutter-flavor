import 'package:flavour_demo/data/repositories/botRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BotQueryState {}

class BotQueryInitial extends BotQueryState {}

class BotQueryFetchInProgress extends BotQueryState {}

class BotQueryFetchSuccess extends BotQueryState {
  final String response;

  BotQueryFetchSuccess({required this.response});
}

class BotQueryFetchFailure extends BotQueryState {
  final String errorMessage;

  BotQueryFetchFailure(this.errorMessage);
}

class BotQueryCubit extends Cubit<BotQueryState> {
  final BotRepository _botRepository;

  BotQueryCubit(this._botRepository) : super(BotQueryInitial());

  void getQueryResponse({required String query}) async {
    emit(BotQueryFetchInProgress());
    try {
      emit(BotQueryFetchSuccess(
          response: await _botRepository.getQueryResponse(query: query)));
    } catch (e) {
      emit(BotQueryFetchFailure(e.toString()));
    }
  }
}
