import 'package:equatable/equatable.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistMovie extends WatchlistMovieEvent {
  const FetchWatchlistMovie();

  @override
  List<Object> get props => [];
}