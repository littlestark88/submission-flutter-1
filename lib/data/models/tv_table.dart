import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/tv.dart';

class TvTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  TvTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TvTable.fromEntity(TvDetail tv) =>
      TvTable(
          id: tv.id,
          name: tv.name,
          posterPath: tv.posterPath,
          overview: tv.overview);

  factory TvTable.fromMap(Map<String, dynamic> map) =>
      TvTable(
          id: map['id'],
          name: map['name'],
          posterPath: map['posterPath'],
          overview: map['overview']);

  factory TvTable.fromTo(TvModel tv) =>
      TvTable(
          id: tv.id,
          name: tv.name,
          posterPath: tv.posterPath,
          overview: tv.overview
      );

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'posterPath': posterPath,
        'overview': overview,
      };

  Tv toEntity() =>
      Tv.watchlist(
          id: id,
          overview: overview,
          posterPath: posterPath,
          name: name,
      );

  @override
  List<Object?> get props => [id, overview, posterPath, name];
}
