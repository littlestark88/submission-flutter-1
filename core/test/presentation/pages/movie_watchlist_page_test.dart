import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_bloc.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_event.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_state.dart';
import 'package:movie/pages/watchlist_movies_page.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class WatchlistMovieEventFake extends Fake implements WatchlistMovieEvent {}

class WatchlistMovieStateFake extends Fake implements WatchlistMovieState {}

void main() {
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUpAll(() {
    registerFallbackValue(WatchlistMovieEventFake());
    registerFallbackValue(WatchlistMovieStateFake());
  });

  setUp(() {
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>.value(
      value: mockWatchlistMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Watchlist Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMovieEmpty());
      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });
    
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMovieLoading());
      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(WatchlistMovieHasData(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockWatchlistMovieBloc.state)
          .thenReturn(const WatchlistMovieError('Error'));

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
