
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_event.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovie;

  TopRatedMovieBloc(this._getTopRatedMovie) : super(TopRatedMovieEmpty()) {
    on<FetchTopRatedMovie>((event, emit) async {
      emit(TopRatedMovieLoading());
      final result = await _getTopRatedMovie.execute();

      result.fold(
            (failure) {
          emit(TopRatedMovieError(failure.message));
        },
            (data) {
          emit(TopRatedMovieHasData(data));
        },
      );
    });
  }
}