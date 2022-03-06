import 'package:core/common/exception.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';


class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late TvLocalDataSourceImpl dataSourceImpl;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSourceImpl = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('TV Local Datasources, Save Watchlist:', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(() => mockDatabaseHelper.insertWatchlistTv(testTvTable))
      .thenAnswer((_) async => 1);
      // act
      final result = await dataSourceImpl.insertWatchlist(testTvTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(() => mockDatabaseHelper.insertWatchlistTv(testTvTable))
          .thenThrow(Exception());
      // act
      final call = dataSourceImpl.insertWatchlist(testTvTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('TV Local Datasources, Remove Watchlist:', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(() => mockDatabaseHelper.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSourceImpl.removeWatchlist(testTvTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(() => mockDatabaseHelper.removeWatchlistTv(testTvTable))
          .thenThrow(Exception());
      // act
      final call = dataSourceImpl.removeWatchlist(testTvTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('TV Local Datasources, Get TV Show Detail By Id', () {
    const tId = 1;

    test('should return TV Show Detail Table when data is found', () async {
      // arrange
      when(() => mockDatabaseHelper.getTvById(tId))
          .thenAnswer((_) async => testTvMap);
      // act
      final result = await dataSourceImpl.getTvId(tId);
      // assert
      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(() => mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSourceImpl.getTvId(tId);
      // assert
      expect(result, null);
    });
  });

  group('TV Local Datasources, Get Watchlist TV Show:', () {
    test('should return list of TVShowsTable from database', () async {
      // arrange
      when(() => mockDatabaseHelper.getWatchlistTv())
          .thenAnswer((_) async => [testTvMap]);
      // act
      final result = await dataSourceImpl.getWatchlistTv();
      // assert
      expect(result, [testTvTable]);
    });
  });
}
