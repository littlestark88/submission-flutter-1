import 'package:equatable/equatable.dart';

abstract class PopularMovieEvent extends Equatable {
  const PopularMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovie extends PopularMovieEvent {
  const FetchPopularMovie();

  @override
  List<Object> get props => [];
}