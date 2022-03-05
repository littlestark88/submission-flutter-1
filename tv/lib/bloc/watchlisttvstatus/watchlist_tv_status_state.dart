import 'package:equatable/equatable.dart';

class WatchlistTvStatusState extends Equatable {
  final bool isAddedWatchlistTv;
  final String message;

  WatchlistTvStatusState({required this.isAddedWatchlistTv, required this.message});

  @override
  List<Object> get props => [isAddedWatchlistTv];
}