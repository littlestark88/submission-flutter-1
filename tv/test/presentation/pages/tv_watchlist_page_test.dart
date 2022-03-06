import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/watchlisttv/watch_tv_bloc.dart';
import 'package:tv/bloc/watchlisttv/watchlist_tv_event.dart';
import 'package:tv/bloc/watchlisttv/watchlist_tv_state.dart';
import 'package:tv/page/watchlist_tv_page.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';



class MockWatchlistTVBloc
    extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

class WatchlistTVEventFake extends Fake implements WatchlistTvEvent {}

class WatchlistTVStateFake extends Fake implements WatchlistTvState {}

void main() {
  late MockWatchlistTVBloc mockWatchlistTVBloc;

  setUpAll(() {
    registerFallbackValue(WatchlistTVEventFake());
    registerFallbackValue(WatchlistTVStateFake());
  });

  setUp(() {
    mockWatchlistTVBloc = MockWatchlistTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvBloc>.value(
      value: mockWatchlistTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Watchlist TV Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTvEmpty());
      await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });
    
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTvLoading());
      await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTvHasData(testTvList));

      await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTvError('Error'));

      await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
