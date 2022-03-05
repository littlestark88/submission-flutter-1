import 'package:equatable/equatable.dart';

abstract class AiringTodayEvent extends Equatable {
  const AiringTodayEvent();

  @override
  List<Object> get props => [];
}

class FetchAiringToday extends AiringTodayEvent {
  FetchAiringToday();

  @override
  List<Object> get props => [];
}