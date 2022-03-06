// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/searchmovie/search_event.dart';
import 'package:tv/bloc/searchtv/search_state_tv.dart';
import 'package:tv/bloc/searchtv/search_tv_bloc.dart';
import 'package:tv/page/search_tv_page.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';



class MockSearchTVBloc extends MockBloc<SearchEvent, SearchStateTv>
    implements SearchTvBloc {}

class SearchTVEventFake extends Fake implements SearchEvent {}

class SearchTVStateFake extends Fake implements SearchStateTv {}

void main() {
  late MockSearchTVBloc mockSearchTVBloc;

  setUpAll(() {
    registerFallbackValue(SearchTVEventFake());
    registerFallbackValue(SearchTVStateFake());
  });

  setUp(() {
    mockSearchTVBloc = MockSearchTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvBloc>.value(
      value: mockSearchTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Search TV Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockSearchTVBloc.state).thenReturn(SearchEmptyTv());
      await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockSearchTVBloc.state)
          .thenReturn(SearchTvLoading());
      await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockSearchTVBloc.state)
          .thenReturn(SearchTvHasData(testTvList));

      await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockSearchTVBloc.state)
          .thenReturn(SearchErrorTv('Error'));

      await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
