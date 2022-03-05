
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/popularmovie/popular_movie_event.dart';
import 'package:movie/bloc/popularmovie/popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieBloc(this._getPopularMovies) : super(PopularMovieEmpty()) {
    on<FetchPopularMovie>((event, emit) async {
      emit(PopularMovieLoading());
      final result = await _getPopularMovies.execute();

      result.fold(
            (failure) {
          emit(PopularMovieError(failure.message));
        },
            (data) {
          emit(PopularMovieHasData(data));
        },
      );
    });
  }
}