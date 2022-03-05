import '../bloc/tvdetail/tv_detail_bloc.dart';
import '../bloc/tvdetail/tv_detail_event.dart';
import '../bloc/tvdetail/tv_detail_state.dart';
import '../bloc/tvrecommendation/tv_recommendation_bloc.dart';
import '../bloc/tvrecommendation/tv_recommendation_event.dart';
import '../bloc/watchlisttvstatus/watchlist_tv_status_bloc.dart';
import 'detail_content_tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvDetailPage extends StatefulWidget {

  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchTvDetail(id: widget.id));
      context
          .read<TvRecommendationBloc>()
          .add(FetchTvRecommendation(id: widget.id));
      context.read<WatchlistTvStatusBloc>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailHasData) {
            return SafeArea(
              child: DetailContentTv(state.result),
            );
          } else if (state is TvDetailError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Expanded(child: Container());
          }
        },
      ),
    );
  }
}


