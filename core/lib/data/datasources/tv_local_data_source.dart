

import '../../common/exception.dart';
import '../models/tv_table.dart';
import 'db/database_helper.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlist(TvTable tv);
  Future<String> removeWatchlist(TvTable tv);
  Future<TvTable?> getTvId(int id);
  Future<List<TvTable>> getWatchlistTv();
  Future<void> cacheAiringTodayTv(List<TvTable> tv);
  Future<List<TvTable>> getCacheAiringTodayTv();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheAiringTodayTv(List<TvTable> tv) async {
    await databaseHelper.clearCacheTv('airing today');
    await databaseHelper.insertCacheTransactionTv(tv, 'airing today');
  }

  @override
  Future<List<TvTable>> getCacheAiringTodayTv() async {
    final result = await databaseHelper.getCacheTv('airing today');
    if(result.isNotEmpty) {
      return result.map((data) => TvTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<TvTable?> getTvId(int id) async {
    final result = await databaseHelper.getTvById(id);
    if(result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTv() async{
    final result = await databaseHelper.getWatchlistTv();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }

  @override
  Future<String> insertWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertWatchlistTv(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeWatchlistTv(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}