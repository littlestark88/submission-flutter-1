import 'package:equatable/equatable.dart';

abstract class TvRecommendationEvent extends Equatable {
  const TvRecommendationEvent();

  @override
  List<Object> get props => [];
}

class FetchTvRecommendation extends TvRecommendationEvent {
  final int id;

  FetchTvRecommendation({required this.id});

  @override
  List<Object> get props => [id];
}