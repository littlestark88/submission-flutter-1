import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

import 'genre_model.dart';

class TvDetailResponse extends Equatable {
  TvDetailResponse({
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
  final List<GenreModel> genres;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
          id: json["id"],
          name: json["name"],
          numberOfEpisodes: json["number_of_episodes"],
          numberOfSeasons: json["number_of_seasons"],
          originalLanguage: json["original_language"],
          originalName: json["original_name"],
          overview: json["overview"],
          popularity: json["popularity"],
          posterPath: json["poster_path"],
          status: json["status"],
          tagLine: json["tagline"],
          type: json["type"],
          voteAverage: json["vote_average"],
          voteCount: json["vote_count"],
          genres: List<GenreModel>.from(
              json["genres"].map((x) => GenreModel.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "status": status,
        "tagline": tagLine,
        "type": type,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
      };

  TvDetail toEntity() {
    return TvDetail(
      id: this.id,
      name: this.name,
      numberOfEpisodes: this.numberOfEpisodes,
      numberOfSeasons: this.numberOfSeasons,
      originalLanguage: this.originalLanguage,
      originalName: this.originalName,
      overview: this.overview,
      popularity: this.popularity,
      posterPath: this.posterPath,
      status: this.status,
      tagLine: this.tagLine,
      type: this.type,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
    );
  }

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
