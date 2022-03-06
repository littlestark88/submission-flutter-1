
import 'package:core/data/models/tv_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';

final testTv = Tv(
  backdropPath: '/wiE9doxiLwq3WCGamDIOb2PqBqc.jpg',
  genreIds: const [18, 80],
  id: 60574,
  name: 'Peaky Blinders',
  originalLanguage: 'en',
  originalName: 'Peaky Blinders',
  overview:
      'A gangster family epic set in 1919 Birmingham, England and centered on a gang who sew razor blades in the peaks of their caps, and their fierce boss Tommy Shelby, who means to move up in the world.',
  popularity: 1041.016,
  posterPath: '/pE8CScObQURsFZ723PSW1K9EGYp.jpg',
  voteAverage: 8.6,
  voteCount: 5373,
);

final testTvList = [testTv];

const testTvDetail = TvDetail(
  id: 1,
  name: 'name',
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  originalLanguage: 'originalLanguage',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 1.0,
  posterPath: 'posterPath',
  status: 'Status',
  tagLine: 'Tagline',
  type: 'Type',
  voteAverage: 1.0,
  voteCount: 1,
  genres: [Genre(id: 1, name: 'Action')],
);

const testTvCache = TvTable(
  id: 60574,
  overview:
      'A gangster family epic set in 1919 Birmingham, England and centered on a gang who sew razor blades in the peaks of their caps, and their fierce boss Tommy Shelby, who means to move up in the world.',
  posterPath: '/pE8CScObQURsFZ723PSW1K9EGYp.jpg',
  name: 'Peaky Blinders',
);

final testTvCacheMap = {
  'id': 60574,
  'overview':
  'A gangster family epic set in 1919 Birmingham, England and centered on a gang who sew razor blades in the peaks of their caps, and their fierce boss Tommy Shelby, who means to move up in the world.',
  'posterPath': '/pE8CScObQURsFZ723PSW1K9EGYp.jpg',
  'name': 'Peaky Blinders',
};

final testTvFromCache = Tv.watchlist(
  id: 60574,
  overview:
  'A gangster family epic set in 1919 Birmingham, England and centered on a gang who sew razor blades in the peaks of their caps, and their fierce boss Tommy Shelby, who means to move up in the world.',
  posterPath: '/pE8CScObQURsFZ723PSW1K9EGYp.jpg',
  name: 'Peaky Blinders',
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
