import 'dart:io';

import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/network_info.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRemoteDataSource extends Mock implements TvRemoteDataSource {}

class MockTVLocalDataSource extends Mock implements TvLocalDataSource {}

class MockTvNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late TvRepositoryImpl repository;
  late MockTVRemoteDataSource mockTVRemoteDataSource;
  late MockTVLocalDataSource mockTVLocalDataSource;
  late MockTvNetworkInfo mockNetworkInfoTv;

  setUp(() {
    mockTVRemoteDataSource = MockTVRemoteDataSource();
    mockTVLocalDataSource = MockTVLocalDataSource();
    mockNetworkInfoTv = MockTvNetworkInfo();
    repository = TvRepositoryImpl(
      localDataSource: mockTVLocalDataSource,
      remoteDataSource: mockTVRemoteDataSource,
      networkInfo: mockNetworkInfoTv,
    );
  });

  final tTVModel = TvModel(
    backdropPath: "/qJYUCO1Q8desX7iVDkwxWVnwacZ.jpg",
    genreIds: const [10759, 16],
    id: 32315,
    name: "Sym-Bionic Titan",
    originalLanguage: "en",
    originalName: "Sym-Bionic Titan",
    overview:
        "Sym-Bionic Titan is an American animated action science fiction television series created by Genndy Tartakovsky, Paul Rudish, and Bryan Andrews for Cartoon Network. The series focuses on a trio made up of the alien princess Ilana, the rebellious soldier Lance, and the robot Octus; the three are able to combine to create the titular Sym-Bionic Titan. A preview of the series was first shown at the 2009 San Diego Comic-Con International, and further details were revealed at Cartoon Network's 2010 Upfront. The series premiered on September 17, 2010, and ended on April 9, 2011. The series is rated TV-PG-V. Cartoon Network initially ordered 20 episodes; Tartakovsky had hoped to expand on that, but the series was not renewed for another season, as the show 'did not have any toys connected to it.' Although Sym-Bionic Titan has never been released on DVD, All 20 episodes are available on iTunes. On October 7, 2012, reruns of Sym-Bionic Titan began airing on Adult Swim's Toonami block.",
    popularity: 9.693,
    posterPath: "/3UdrghLghvYnsVohWM160RHKPYQ.jpg",
    voteAverage: 8.8,
    voteCount: 85,
  );

  final tTV = Tv(
    backdropPath: "/qJYUCO1Q8desX7iVDkwxWVnwacZ.jpg",
    genreIds: const [10759, 16],
    id: 32315,
    name: "Sym-Bionic Titan",
    originalLanguage: "en",
    originalName: "Sym-Bionic Titan",
    overview:
        "Sym-Bionic Titan is an American animated action science fiction television series created by Genndy Tartakovsky, Paul Rudish, and Bryan Andrews for Cartoon Network. The series focuses on a trio made up of the alien princess Ilana, the rebellious soldier Lance, and the robot Octus; the three are able to combine to create the titular Sym-Bionic Titan. A preview of the series was first shown at the 2009 San Diego Comic-Con International, and further details were revealed at Cartoon Network's 2010 Upfront. The series premiered on September 17, 2010, and ended on April 9, 2011. The series is rated TV-PG-V. Cartoon Network initially ordered 20 episodes; Tartakovsky had hoped to expand on that, but the series was not renewed for another season, as the show 'did not have any toys connected to it.' Although Sym-Bionic Titan has never been released on DVD, All 20 episodes are available on iTunes. On October 7, 2012, reruns of Sym-Bionic Titan began airing on Adult Swim's Toonami block.",
    popularity: 9.693,
    posterPath: "/3UdrghLghvYnsVohWM160RHKPYQ.jpg",
    voteAverage: 8.8,
    voteCount: 85,
  );

  final tTVModelList = <TvModel>[tTVModel];
  final tTVList = <Tv>[tTV];

  group('TV Repository, On The Air TV Shows:', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getAiringTodayTv())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getAiringTodayTv();
      // assert
      verify(() => mockTVRemoteDataSource.getAiringTodayTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getAiringTodayTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getAiringTodayTv();
      // assert
      verify(() => mockTVRemoteDataSource.getAiringTodayTv());
      expect(result, equals(const Left(ServerFailure('Error Server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getAiringTodayTv())
          .thenThrow(const SocketException('Failed to connect to he network'));
      // act
      final result = await repository.getAiringTodayTv();
      // assert
      verify(() => mockTVRemoteDataSource.getAiringTodayTv());
      expect(result,
          equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('TV Repository, Popular TV Shows:', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getPopularTv())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getPopularTv();
      // assert
      verify(() => mockTVRemoteDataSource.getPopularTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getPopularTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTv();
      // assert
      verify(() => mockTVRemoteDataSource.getPopularTv());
      expect(result, equals(const Left(ServerFailure('Error Server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getPopularTv())
          .thenThrow(const SocketException('Failed to connect to he network'));
      // act
      final result = await repository.getPopularTv();
      // assert
      verify(() => mockTVRemoteDataSource.getPopularTv());
      expect(result,
          equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('TV Repository, Top Rated TV Shows:', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getTopRatedTv())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getTopRatedTv();
      // assert
      verify(() => mockTVRemoteDataSource.getTopRatedTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getTopRatedTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTv();
      // assert
      verify(() => mockTVRemoteDataSource.getTopRatedTv());
      expect(result, equals(const Left(ServerFailure('Error Server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getTopRatedTv())
          .thenThrow(const SocketException('Failed to connect to he network'));
      // act
      final result = await repository.getTopRatedTv();
      // assert
      verify(() => mockTVRemoteDataSource.getTopRatedTv());
      expect(result,
          equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('TV Repository, Get TV Detail:', () {
    const tId = 1;
    final tTVResponse = TvDetailResponse(
        genres: const [GenreModel(id: 1, name: "Action")],
        id: 1,
        name: "Name",
        numberOfEpisodes: 1,
        numberOfSeasons: 1,
        originalLanguage: "en",
        originalName: "Original Name",
        overview: "Overview",
        popularity: 1.0,
        posterPath: "/path.jpg",
        status: "Status",
        type: "Action",
        voteAverage: 1.0,
        voteCount: 1,
        tagLine: 'TagLine');

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTVResponse);
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(() => mockTVRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTVShowDetail)));
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getTopRatedTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTv();
      // assert
      verify(() => mockTVRemoteDataSource.getTopRatedTv());
      expect(result, equals(const Left(ServerFailure('Error Server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getTopRatedTv())
          .thenThrow(const SocketException('Failed to connect to he network'));
      // act
      final result = await repository.getTopRatedTv();
      // assert
      verify(() => mockTVRemoteDataSource.getTopRatedTv());
      expect(result,
          equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('TV Repository, Get TV Shows Recomendations:', () {
    final tTVList = <TvModel>[];
    const tId = 1;

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getRecommendationsTv(tId))
          .thenAnswer((_) async => tTVList);
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(() => mockTVRemoteDataSource.getRecommendationsTv(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTVList));
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getRecommendationsTv(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(() => mockTVRemoteDataSource.getRecommendationsTv(tId));
      expect(result, equals(const Left(ServerFailure('Error Server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.getRecommendationsTv(tId))
          .thenThrow(const SocketException('Failed to connect to he network'));
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(() => mockTVRemoteDataSource.getRecommendationsTv(tId));
      expect(result,
          equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('TV Repository, Get Search TV Shows:', () {
    const tQuery = 'titan';

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.searchTv(tQuery))
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      verify(() => mockTVRemoteDataSource.searchTv(tQuery));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.searchTv(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      expect(result, const Left(ServerFailure('Error Server')));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockTVRemoteDataSource.searchTv(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      expect(result,
          equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('TV Repository. Save Watchlist:', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(() => mockTVLocalDataSource.insertWatchlist(testTVTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTv(testTVShowDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(() => mockTVLocalDataSource.insertWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistTv(testTVShowDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('TV Repository, Remove Watchlist:', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(() => mockTVLocalDataSource.removeWatchlist(testTVTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTv(testTVShowDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(() => mockTVLocalDataSource.removeWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTv(testTVShowDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('TV Repository, Watchlist Status:', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(() => mockTVLocalDataSource.getTvId(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistTv(tId);
      // assert
      expect(result, false);
    });
  });

  group('TV Repository, Get Watchlist TV Shows:', () {
    test('should return list of Movies', () async {
      // arrange
      when(() => mockTVLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTVTable]);
      // act
      final result = await repository.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTV]);
    });
  });
}
