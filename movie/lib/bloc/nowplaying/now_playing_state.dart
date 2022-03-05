import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class NowPlayingState extends Equatable {
  const NowPlayingState();

  @override
  List<Object> get props => [];
}

class NowPlayingEmpty extends NowPlayingState {}

class NowPlayingLoading extends NowPlayingState {}

class NowPlayingError extends NowPlayingState {
  final String message;
  const NowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingHasData extends NowPlayingState {
  final List<Movie> result;
  const NowPlayingHasData(this.result);

  @override
  List<Object> get props => [result];
}
