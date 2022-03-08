import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../common/network_info.dart';
import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/repositories/tv_repository.dart';
import '../datasources/tv_local_data_source.dart';
import '../datasources/tv_remote_data_source.dart';
import '../models/tv_table.dart';

class TvRepositoryImpl implements TvRepository {

  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Tv>>> getAiringTodayTv() async {
    if(await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAiringTodayTv();
        await localDataSource.cacheAiringTodayTv(
          result.map((tv) => TvTable.fromTo(tv)).toList());
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return const Left(ServerFailure(''));
      }
    } else {
      try {
        final result = await localDataSource.getCacheAiringTodayTv();
        return Right(result.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async {
    try {
      final result = await remoteDataSource.getPopularTv();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async {
    try {
      final result = await remoteDataSource.getTopRatedTv();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getRecommendationsTv(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTv() async {
    final result = await localDataSource.getWatchlistTv();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchlistTv(int id) async {
    final result = await localDataSource.getTvId(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlistTv(TvDetail tv) async {
    try{
      final result = await localDataSource.removeWatchlist(TvTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlistTv(TvDetail tv) async{
    try{
      final result = await localDataSource.insertWatchlist(TvTable.fromEntity(tv));
      return Right(result);
    }on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async {
    try{
      final result = await remoteDataSource.searchTv(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

}