import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/page/popular_tv_page.dart';
import '../bloc/airingtoday/airing_today_bloc.dart';
import '../bloc/airingtoday/airing_today_event.dart';
import '../bloc/airingtoday/airing_today_state.dart';
import '../bloc/populartv/popular_tv_bloc.dart';
import '../bloc/populartv/popular_tv_event.dart';
import '../bloc/populartv/popular_tv_state.dart';
import '../bloc/topratedtv/top_rated_tv_bloc.dart';
import '../bloc/topratedtv/top_rated_tv_event.dart';
import '../bloc/topratedtv/top_rated_tv_state.dart';
import 'search_tv_page.dart';
import 'top_rated_tv_page.dart';
import 'tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv';

  @override
  _TvPageState createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AiringTodayBloc>().add(FetchAiringToday()));
    Future.microtask(() => context.read<PopularTvBloc>().add(FetchPopularTv()));
    Future.microtask(() => context.read<TopRatedTvBloc>().add(FetchTopRatedTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ditonton Tv'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing Tv',
                style: kHeading6,
              ),
              BlocBuilder<AiringTodayBloc, AiringTodayState>(
                  builder: (context, state) {
                if (state is AiringTodayLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AiringTodayHasData) {
                  final result = state.result;
                  return TvList(result);
                } else if (state is AiringTodayError){
                  return Text(state.message);
                } else {
                  return Expanded(child: Container());
                }
              }),
              _buildSubHeading(
                title: 'Popular Tv',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvBloc, PopularTvState>(
                  builder: (context, state) {
                if (state is PopularTvLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTvHasData) {
                  final result = state.result;
                  return TvList(result);
                } else if (state is PopularTvError) {
                  return Text(state.message);
                } else {
                  return Expanded(child: Container());
                }
              }),
              _buildSubHeading(
                title: 'Top Rated Tv',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                  builder: (context, state) {
                    if (state is TopRatedTvLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TopRatedTvHasData) {
                      final result = state.result;
                      return TvList(result);
                    } else if (state is TopRatedTvError) {
                      return Text(state.message);
                    } else {
                      return Expanded(child: Container());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        )
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tv;

  TvList(this.tv);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final dataTv = tv[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, TvDetailPage.ROUTE_NAME,
                    arguments: dataTv.id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${dataTv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, data) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tv.length,
      ),
    );
  }
}
