import 'dart:io';

import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';
import '../../helper/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tTvModel = TvModel(
      backdropPath: "/wiE9doxiLwq3WCGamDIOb2PqBqc.jpg",
      genreIds: [
      18,
      80
      ],
      id: 60574,
      name: "Peaky Blinders",
      originalLanguage: "en",
      originalName: "Peaky Blinders",
      overview: "A gangster family epic set in 1919 Birmingham, England and centered on a gang who sew razor blades in the peaks of their caps, and their fierce boss Tommy Shelby, who means to move up in the world.",
      popularity: 1041.016,
      posterPath: "/pE8CScObQURsFZ723PSW1K9EGYp.jpg",
      voteAverage: 8.6,
      voteCount: 5373
  );

  final tTv = Tv(
      backdropPath: "/wiE9doxiLwq3WCGamDIOb2PqBqc.jpg",
      genreIds: const [
        18,
        80
      ],
      id: 60574,
      name: "Peaky Blinders",
      originalLanguage: "en",
      originalName: "Peaky Blinders",
      overview: "A gangster family epic set in 1919 Birmingham, England and centered on a gang who sew razor blades in the peaks of their caps, and their fierce boss Tommy Shelby, who means to move up in the world.",
      popularity: 1041.016,
      posterPath: "/pE8CScObQURsFZ723PSW1K9EGYp.jpg",
      voteAverage: 8.6,
      voteCount: 5373
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('Airing Today Tv', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAiringTodayTv())
          .thenAnswer((_) async => []);
      // act
      await repository.getAiringTodayTv();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getAiringTodayTv())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getAiringTodayTv();
        // assert
        verify(mockRemoteDataSource.getAiringTodayTv());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getAiringTodayTv())
            .thenAnswer((_) async => tTvModelList);
        // act
        await repository.getAiringTodayTv();
        // assert
        verify(mockRemoteDataSource.getAiringTodayTv());
        verify(mockLocalDataSource.cacheAiringTodayTv([testTvCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getAiringTodayTv())
            .thenThrow(ServerException());
        // act
        final result = await repository.getAiringTodayTv();
        // assert
        verify(mockRemoteDataSource.getAiringTodayTv());
        expect(result, equals(const Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCacheAiringTodayTv())
            .thenAnswer((_) async => [testTvCache]);
        // act
        final result = await repository.getAiringTodayTv();
        // assert
        verify(mockLocalDataSource.getCacheAiringTodayTv());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCacheAiringTodayTv())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getAiringTodayTv();
        // assert
        verify(mockLocalDataSource.getCacheAiringTodayTv());
        expect(result, const Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular Tv', () {
    test('should return movie list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getPopularTv();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTv();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTv();
      // assert
      expect(
          result, const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv', () {
    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv())
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getTopRatedTv();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTv();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTv();
      // assert
      expect(
          result, const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Detail', () {
    const tId = 1;
    const tTvResponse = TvDetailResponse(
      id: 1,
      name: 'name',
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originalLanguage: 'originalLanguage',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      status: 'Status',
      tagLine: 'Tagline',
      type: 'Type',
      voteAverage: 1,
      voteCount: 1,
      genres: [GenreModel(id: 1, name: 'Action')],
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result,
          equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Recommendations', () {
    final tTvList = <TvModel>[];
    const tId = 1;

    test('should return data (movie list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getRecommendationsTv(tId))
          .thenAnswer((_) async => tTvList);
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getRecommendationsTv(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getRecommendationsTv(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getRecommendationsTv(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getRecommendationsTv(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getRecommendationsTv(tId));
      expect(result,
          equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search Tv', () {
    const tQuery = 'Picky Blinders';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTv(tQuery);
      // assert
      expect(
          result, const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTv(testTvDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistTv(testTvDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockLocalDataSource.getTvId(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistTv(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv', () {
    test('should return list of Tv', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
