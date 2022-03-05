import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class SearchStateTv extends Equatable {
  const SearchStateTv();

  @override
  List<Object> get props => [];
}

class SearchEmptyTv extends SearchStateTv {}

class SearchTvLoading extends SearchStateTv {}

class SearchErrorTv extends SearchStateTv {
  final String message;
  SearchErrorTv(this.message);
  @override
  List<Object> get props => [message];
}

class SearchTvHasData extends SearchStateTv {
  final List<Tv> result;

  SearchTvHasData(this.result);

  @override
  List<Object> get props => [result];
}