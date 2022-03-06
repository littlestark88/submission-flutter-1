import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_bloc.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_event.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_state.dart';
import 'package:tv/page/top_rated_tv_page.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';

class MockTopRatedTVBloc
    extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

class TopRatedTVEventFake extends Fake implements TopRatedTvEvent {}

class TopRatedTVStateFake extends Fake implements TopRatedTvState {}

void main() {
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTVEventFake());
    registerFallbackValue(TopRatedTVStateFake());
  });

  setUp(() {
    mockTopRatedTVBloc = MockTopRatedTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>.value(
      value: mockTopRatedTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Top Rated TV Page:', () {

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockTopRatedTVBloc.state)
          .thenReturn(TopRatedTvHasData(testTvList));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockTopRatedTVBloc.state)
          .thenReturn(TopRatedTvError('Error'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}