import 'package:equatable/equatable.dart';

import 'genre.dart';

class TvDetail extends Equatable {
  TvDetail({
    required this.id,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.status,
    required this.tagLine,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
  });

  final int id;
  final String? name;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double popularity;
  final String? posterPath;
  final String? status;
  final String? tagLine;
  final String? type;
  final double? voteAverage;
  final int? voteCount;
  final List<Genre>? genres;

  @override
  List<Object?> get props => [
    id,
    name,
    numberOfEpisodes,
    numberOfSeasons,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    status,
    tagLine,
    type,
    voteAverage,
    voteCount,
    genres,
  ];
}
