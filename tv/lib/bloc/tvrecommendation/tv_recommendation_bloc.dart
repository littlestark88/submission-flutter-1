import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_event.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_state.dart';

class TvRecommendationBloc extends Bloc<TvRecommendationEvent, TvRecommendationState> {
  final GetTvRecommendations _getTvRecommendations;

  TvRecommendationBloc(this._getTvRecommendations) : super(TvRecommendationEmpty()) {
    on<FetchTvRecommendation>((event, emit) async {
      final id = event.id;
      emit(TvRecommendationLoading());
      final result = await _getTvRecommendations.execute(id);

      result.fold(
            (failure) {
          emit(TvRecommendationError(failure.message));
        },
            (data) {
          emit(TvRecommendationHasData(data));
        },
      );
    });
  }
}