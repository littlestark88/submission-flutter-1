import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/searchmovie/search_bloc.dart';
import 'package:movie/bloc/searchmovie/search_event.dart';
import 'package:movie/bloc/searchmovie/search_state.dart';
import 'package:movie/pages/search_page.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockSearchMovieBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class SearchMovieEventFake extends Fake implements SearchEvent {}

class SearchMovieStateFake extends Fake implements SearchState {}

void main() {
  late MockSearchMovieBloc mockSearchMovieBloc;

  setUpAll(() {
    registerFallbackValue(SearchMovieEventFake());
    registerFallbackValue(SearchMovieStateFake());
  });

  setUp(() {
    mockSearchMovieBloc = MockSearchMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchBloc>.value(
      value: mockSearchMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Search Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state).thenReturn(SearchEmpty());
      await tester.pumpWidget(_makeTestableWidget(SearchPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(SearchLoading());
      await tester.pumpWidget(_makeTestableWidget(SearchPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(SearchHasData(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(SearchPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(const SearchError('Error'));

      await tester.pumpWidget(_makeTestableWidget(SearchPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
