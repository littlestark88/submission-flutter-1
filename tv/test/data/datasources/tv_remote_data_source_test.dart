import 'dart:convert';
import 'package:core/common/constants.dart';
import 'package:core/common/exception.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../helper/json_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {

  late TvRemoteDataSourceImpl dataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('TV Remote Datasources, Get Airing Today :', () {
    // final tTVList = TvResponse.fromJson(
    //         json.decode(readJson('helper/dummy_data/airing_today.json')))
    //     .tvList;

  //   test('should return list of TV Show Model when the response code is 200',
  //       () async {
  //     // arrange
  //     when(() =>
  //             mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
  //         .thenAnswer((_) async => http.Response(
  //             readJson('helper/dummy_data/airing_today.json'), 200));
  //     // act
  //     final result = await dataSourceImpl.getAiringTodayTv();
  //     // assert
  //     expect(result, equals(tTVList));
  //   });
  //
  //   test(
  //       'should throw a ServerException when the response code is 404 or other',
  //       () async {
  //     // arrange
  //     when(() =>
  //             mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
  //         .thenAnswer((_) async => http.Response('Not Found', 404));
  //     // act
  //     final call = dataSourceImpl.getAiringTodayTv();
  //     // assert
  //     expect(() => call, throwsA(isA<ServerException>()));
  //   });
  });

  group('TV Remote Datasources, Get Popular TV Shows:', () {
    final tTVList = TvResponse.fromJson(
            json.decode(readJson('helper/dummy_data/popular.json')))
        .tvList;

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/popular.json'), 200));
      // act
      final result = await dataSourceImpl.getPopularTv();
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getPopularTv();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('TV Remote Datasources, Get Top Rated TV Shows:', () {
    final tTVList = TvResponse.fromJson(
            json.decode(readJson('helper/dummy_data/top_rated.json')))
        .tvList;

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(() =>
              mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/top_rated.json'), 200));
      // act
      final result = await dataSourceImpl.getTopRatedTv();
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(() =>
              mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getTopRatedTv();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('TV Remote Datasources, Get TV Show Detail:', () {
    const tId = 1;
    final tTVDetail = TvDetailResponse.fromJson(
        json.decode(readJson('helper/dummy_data/tv_detail.json')));

    test('should return TV Show detail when the response code is 200',
        () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/tv_detail.json'), 200));
      // act
      final result = await dataSourceImpl.getTvDetail(tId);
      // assert
      expect(result, equals(tTVDetail));
    });

    test('should throw Server Execption when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getTvDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('TV Remote Datasources, Get Recomendation TV Shows:', () {
    final tTVList = TvResponse.fromJson(json.decode(
            readJson('helper/dummy_data/tv_recommendations.json')))
        .tvList;
    const tId = 1;

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(() => mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/tv_recommendations.json'),
              200));
      // act
      final result = await dataSourceImpl.getRecommendationsTv(tId);
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getRecommendationsTv(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('TV Remote Datasources, Get Search TV Shows:', () {
    final tTVList = TvResponse.fromJson(
            json.decode(readJson('helper/dummy_data/search_titan.json')))
        .tvList;
    const tQuery = 'Titan';

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(() => mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/search_titan.json'), 200));
      // act
      final result = await dataSourceImpl.searchTv(tQuery);
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.searchTv(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
