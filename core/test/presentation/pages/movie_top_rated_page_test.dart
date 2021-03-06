import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_bloc.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_event.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_state.dart';
import 'package:movie/pages/top_rated_movies_page.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class TopRatedMovieEventFake extends Fake implements TopRatedMovieEvent {}

class TopRatedMovieStateFake extends Fake implements TopRatedMovieState {}

void main() {
  late MockTopRatedMovieBloc mockTopRatedMovieBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedMovieEventFake());
    registerFallbackValue(TopRatedMovieStateFake());
  });

  setUp(() {
    mockTopRatedMovieBloc = MockTopRatedMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>.value(
      value: mockTopRatedMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Popular Movie Page:', () {
    
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockTopRatedMovieBloc.state)
          .thenReturn(TopRatedMovieLoading());
      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockTopRatedMovieBloc.state)
          .thenReturn(TopRatedMovieHasData(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockTopRatedMovieBloc.state)
          .thenReturn(const TopRatedMovieError('Error'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}