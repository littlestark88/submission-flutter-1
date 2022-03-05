import 'package:core/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailError extends TvDetailState {
  final String message;
  TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvDetailHasData extends TvDetailState {
  final TvDetail result;
  TvDetailHasData(this.result);

  @override
  List<Object> get props => [result];
}