import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/pages/popular_movies_page.dart';
import 'package:movie/pages/search_page.dart';
import 'package:movie/pages/top_rated_movies_page.dart';

import '../bloc/nowplaying/now_playing_bloc.dart';
import '../bloc/nowplaying/now_playing_event.dart';
import '../bloc/nowplaying/now_playing_state.dart';
import '../bloc/popularmovie/popular_movie_bloc.dart';
import '../bloc/popularmovie/popular_movie_event.dart';
import '../bloc/popularmovie/popular_movie_state.dart';
import '../bloc/topratedmovie/top_rated_movie_bloc.dart';
import '../bloc/topratedmovie/top_rated_movie_event.dart';
import '../bloc/topratedmovie/top_rated_movie_state.dart';
import 'movie_detail_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<NowPlayingBloc>().add(const FetchNowPlaying()));
    Future.microtask(
        () => context.read<PopularMovieBloc>().add(const FetchPopularMovie()));
    Future.microtask(
            () => context.read<TopRatedMovieBloc>().add(const FetchTopRatedMovie()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              // FirebaseCrashlytics.instance.crash();
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<NowPlayingBloc, NowPlayingState>(
                  builder: (context, state) {
                if (state is NowPlayingLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NowPlayingHasData) {
                  final result = state.result;
                  return MovieList(result);
                } else if (state is NowPlayingError) {
                  return Text(state.message);
                } else {
                  return Expanded(child: Container());
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularMovieBloc, PopularMovieState>(
                  builder: (context, state) {
                if (state is PopularMovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularMovieHasData) {
                  final result = state.result;
                  return MovieList(result);
                } else if (state is PopularMovieError) {
                  return Text(state.message);
                } else {
                  return Expanded(child: Container());
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
                  builder: (context, state) {
                    if (state is TopRatedMovieLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TopRatedMovieHasData) {
                      final result = state.result;
                      return MovieList(result);
                    } else if (state is TopRatedMovieError) {
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
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
