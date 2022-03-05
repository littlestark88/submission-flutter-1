import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvRecommendationState extends Equatable {
  const TvRecommendationState();

  @override
  List<Object> get props => [];
}

class TvRecommendationEmpty extends TvRecommendationState {}

class TvRecommendationLoading extends TvRecommendationState {}

class TvRecommendationError extends TvRecommendationState {
  final String message;
  TvRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class TvRecommendationHasData extends TvRecommendationState {
  final List<Tv> result;
  TvRecommendationHasData(this.result);

  @override
  List<Object> get props => [result];
}