import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/constants.dart';
import '../../common/exception.dart';
import '../models/tv_detail_model.dart';
import '../models/tv_model.dart';
import '../models/tv_response.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getAiringTodayTv();
  Future<List<TvModel>> getPopularTv();
  Future<List<TvModel>> getTopRatedTv();
  Future<TvDetailResponse> getTvDetail(int id);
  Future<List<TvModel>> getRecommendationsTv(int id);
  Future<List<TvModel>> searchTv(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});


  @override
  Future<List<TvModel>> getAiringTodayTv() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/3/tv/airing_today?$API_KEY'));

    if(response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTv() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/3/tv/popular?$API_KEY'));

    if(response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getRecommendationsTv(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/3/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTv() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/3/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    final response =
        await client.get(Uri.parse('$BASE_URL/3/tv/$id?$API_KEY'));

    if(response.statusCode == 200) {
      return TvDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTv(String query) async {
    final response = await client.get(Uri.parse('$BASE_URL/3/search/tv?$API_KEY&query=$query'));

    if(response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

}