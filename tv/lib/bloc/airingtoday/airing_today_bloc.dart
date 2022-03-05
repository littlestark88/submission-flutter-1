import 'package:core/domain/usecases/get_airing_today_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'airing_today_event.dart';
import 'airing_today_state.dart';

class AiringTodayBloc extends Bloc<AiringTodayEvent, AiringTodayState> {
  final GetAiringTodayTv _getAiringTodayTv;

  AiringTodayBloc(this._getAiringTodayTv) : super(AiringTodayEmpty()) {
    on<FetchAiringToday>((event, emit) async {
      emit(AiringTodayLoading());
      final result = await _getAiringTodayTv.execute();

      result.fold(
            (failure) {
          emit(AiringTodayError(failure.message));
        },
            (data) {
          emit(AiringTodayHasData(data));
        },
      );
    });
  }
}