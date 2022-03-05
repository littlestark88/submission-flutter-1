import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/moviedetail/movie_detail_bloc.dart';
import 'package:movie/bloc/moviedetail/movie_detail_event.dart';
import 'package:movie/bloc/moviedetail/movie_detail_state.dart';
import 'package:movie/bloc/movierecommendation/movie_recommendation_bloc.dart';
import 'package:movie/bloc/movierecommendation/movie_recommendation_event.dart';
import 'package:movie/bloc/movierecommendation/movie_recommendation_state.dart';
import 'package:movie/bloc/watchliststatusmovie/watchlist_movie_status_bloc.dart';
import 'package:movie/bloc/watchliststatusmovie/watchlist_movie_status_state.dart';
import 'package:movie/pages/movie_detail_page.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockDetailMovieBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class DetailMovieEventFake extends Fake implements MovieDetailEvent {}

class DetailMovieStateFake extends Fake implements MovieDetailState {}

class MockRecommendationMovieBloc
    extends MockBloc<MovieRecommendationEvent, MovieRecommendationState>
    implements MovieRecommendationBloc {}

class RecommendationMovieEventFake extends Fake
    implements MovieRecommendationEvent {}

class RecommendationMovieStateFake extends Fake
    implements MovieRecommendationState {}

class MockWatchlistStatusMovieCubit extends MockCubit<WatchlistMovieStatusState>
    implements WatchlistMovieStatusBloc {}

class WatchlistStatusMovieStateFake extends Fake
    implements WatchlistMovieStatusState {}

void main() {
  late MockDetailMovieBloc mockDetailMovieBloc;
  late MockRecommendationMovieBloc mockRecommendationMovieBloc;
  late MockWatchlistStatusMovieCubit mockWatchlistStatusMovieCubit;

  setUpAll(() {
    registerFallbackValue(DetailMovieEventFake());
    registerFallbackValue(DetailMovieStateFake());
  });

  setUp(() {
    mockDetailMovieBloc = MockDetailMovieBloc();
    mockRecommendationMovieBloc = MockRecommendationMovieBloc();
    mockWatchlistStatusMovieCubit = MockWatchlistStatusMovieCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockDetailMovieBloc),
        BlocProvider<MovieRecommendationBloc>.value(
            value: mockRecommendationMovieBloc),
        BlocProvider<WatchlistMovieStatusBloc>.value(
          value: mockWatchlistStatusMovieCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Detail Movie Page:', () {

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(MovieDetailLoading());
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistMovieStatusState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(MovieRecommendationLoading());

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(const MovieDetailHasData(testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistMovieStatusState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(MovieRecommendationHasData(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);
      final listViewFinder = find.byType(ListView);

      expect(buttonFinder, findsOneWidget);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(const MovieDetailError('Error'));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistMovieStatusState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(const MovieRecommendationError('Error'));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });

  group('Movie Page, Detail Movie Widgets:', () {
    testWidgets(
        'watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockDetailMovieBloc.state)
          .thenReturn(const MovieDetailHasData(testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistMovieStatusState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(MovieRecommendationHasData(testMovieList));

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockDetailMovieBloc.state)
          .thenReturn(const MovieDetailHasData(testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistMovieStatusState(isAddedWatchlist: true, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(MovieRecommendationHasData(testMovieList));

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}
