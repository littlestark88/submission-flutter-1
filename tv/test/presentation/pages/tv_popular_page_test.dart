import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/populartv/popular_tv_bloc.dart';
import 'package:tv/bloc/populartv/popular_tv_event.dart';
import 'package:tv/bloc/populartv/popular_tv_state.dart';
import 'package:tv/page/popular_tv_page.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';



class MockPopularTVBloc
    extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

class PopularTVEventFake extends Fake implements PopularTvEvent {}

class PopularTVStateFake extends Fake implements PopularTvState {}

void main() {
  late MockPopularTVBloc mockPopularTVBloc;

  setUpAll(() {
    registerFallbackValue(PopularTVEventFake());
    registerFallbackValue(PopularTVStateFake());
  });

  setUp(() {
    mockPopularTVBloc = MockPopularTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>.value(
      value: mockPopularTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Popular TV Page:', () {

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTvHasData(testTvList));

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTvError('Error'));

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}