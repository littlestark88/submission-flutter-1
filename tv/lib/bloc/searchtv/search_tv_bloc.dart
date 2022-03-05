import 'package:core/domain/usecases/search_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/searchmovie/search_event.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv/bloc/searchtv/search_state_tv.dart';

class SearchTvBloc extends Bloc<SearchEvent, SearchStateTv> {
  final SearchTv _searchTv;

  SearchTvBloc(this._searchTv): super(SearchEmptyTv()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchTvLoading());
      final result = await _searchTv.execute(query);

      result.fold(
          (failure) {
            emit(SearchErrorTv(failure.message));
          },
          (data) {
            emit(SearchTvHasData(data));
          },
      );
    }, transformer: debounce(const Duration(microseconds: 5000)));
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}