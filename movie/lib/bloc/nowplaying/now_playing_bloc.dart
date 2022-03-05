import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'now_playing_event.dart';
import 'now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingBloc(this._getNowPlayingMovies) : super(NowPlayingEmpty()) {
    on<FetchNowPlaying>((event, emit) async {
      emit(NowPlayingLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(NowPlayingError(failure.message));
        },
        (data) {
          emit(NowPlayingHasData(data));
        },
      );
    });
  }
}

