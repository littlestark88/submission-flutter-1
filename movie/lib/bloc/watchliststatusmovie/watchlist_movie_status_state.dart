import 'package:equatable/equatable.dart';

class WatchlistMovieStatusState extends Equatable {
  final bool isAddedWatchlist;
  final String message;

  const WatchlistMovieStatusState({required this.isAddedWatchlist, required this.message});

  @override
  List<Object> get props => [isAddedWatchlist];
}