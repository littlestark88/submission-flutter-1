import 'dart:convert';

import 'package:core/common/exception.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helper/json_reader.dart';
import '../../helper/test_helper_tv.mocks.dart';

void main() {
  const API_KEY = 'api_key=e2487f73d71bda6db4d172a313647327';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Airing Today Tv', () {
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('helper/dummy_data/tv_airing_today.json')))
        .tvList;

    test('should return list of Tv Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('helper/dummy_data/tv_airing_today.json'), 200));
          // act
          final result = await dataSource.getAiringTodayTv();
          // assert
          expect(result, equals(tTvList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getAiringTodayTv();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Popular Tv', () {
    final tTvList =
        TvResponse.fromJson(json.decode(readJson('helper/dummy_data/tv_popular.json')))
            .tvList;

    test('should return list of tv when response is success (200)',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('helper/dummy_data/tv_popular.json'), 200));
          // act
          final result = await dataSource.getPopularTv();
          // assert
          expect(result, tTvList);
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularTv();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated Tv', () {
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('helper/dummy_data/tv_top_rated.json')))
        .tvList;

    test('should return list of tv when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('helper/dummy_data/tv_top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTv();
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTopRatedTv();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv detail', () {
    final tId = 2;
    final tTvDetail = TvDetailResponse.fromJson(
        json.decode(readJson('helper/dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('helper/dummy_data/tv_detail.json'), 200));
      // act
      final result = await dataSource.getTvDetail(tId);
      // assert
      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTvDetail(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv recommendations', () {
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('helper/dummy_data/tv_recommendations.json')))
        .tvList;
    final tId = 1;

    test('should return list of Tv Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/tv_recommendations.json'), 200));
          // act
          final result = await dataSource.getRecommendationsTv(tId);
          // assert
          expect(result, equals(tTvList));
        });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getRecommendationsTv(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('search tv', () {
    final tSearchResult = TvResponse.fromJson(
        json.decode(readJson('helper/dummy_data/search_peaky_blinders_tv.json')))
        .tvList;
    final tQuery = 'Peaky Blinders';

    test('should return list of Tv when response code is 200', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('helper/dummy_data/search_peaky_blinders_tv.json'), 200));
      // act
      final result = await dataSource.searchTv(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchTv(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });
}