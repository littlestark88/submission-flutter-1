import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/tvdetail/tv_detail_bloc.dart';
import 'package:tv/bloc/tvdetail/tv_detail_event.dart';
import 'package:tv/bloc/tvdetail/tv_detail_state.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_bloc.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_event.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_state.dart';
import 'package:tv/bloc/watchlisttvstatus/watchlist_tv_status_bloc.dart';
import 'package:tv/bloc/watchlisttvstatus/watchlist_tv_status_state.dart';
import 'package:tv/page/tv_detail_page.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';


class MockDetailTVBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class DetailTVEventFake extends Fake implements TvDetailEvent {}

class DetailTVStateFake extends Fake implements TvDetailState {}

class MockRecommendationTVBloc
    extends MockBloc<TvRecommendationEvent, TvRecommendationState>
    implements TvRecommendationBloc {}

class RecommendationTVEventFake extends Fake implements TvRecommendationEvent {}

class RecommendationTVStateFake extends Fake implements TvRecommendationState {}

class MockWatchlistTvStatusBloc extends MockCubit<WatchlistTvStatusState>
    implements WatchlistTvStatusBloc {}

class WatchlistStatusTVStateFake extends Fake
    implements WatchlistTvStatusState {}

void main() {
  late MockDetailTVBloc mockDetailTVBloc;
  late MockRecommendationTVBloc mockRecommendationTVBloc;
  late MockWatchlistTvStatusBloc mockWatchlistStatusTVCubit;

  setUpAll(() {
    registerFallbackValue(DetailTVEventFake());
    registerFallbackValue(DetailTVStateFake());
  });

  setUp(() {
    mockDetailTVBloc = MockDetailTVBloc();
    mockRecommendationTVBloc = MockRecommendationTVBloc();
    mockWatchlistStatusTVCubit = MockWatchlistTvStatusBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>.value(value: mockDetailTVBloc),
        BlocProvider<TvRecommendationBloc>.value(
            value: mockRecommendationTVBloc),
        BlocProvider<WatchlistTvStatusBloc>.value(
          value: mockWatchlistStatusTVCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Detail TV Page:', () {

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockDetailTVBloc.state).thenReturn(TvDetailLoading());
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          WatchlistTvStatusState(isAddedWatchlistTv: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(TvRecommendationLoading());

      await tester.pumpWidget(
          _makeTestableWidget(TvDetailPage(id: testTvDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockDetailTVBloc.state)
          .thenReturn(TvDetailHasData(testTvDetail));
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          WatchlistTvStatusState(isAddedWatchlistTv: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(TvRecommendationHasData(testTvList));

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(
        id: testTvDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);
      final listViewFinder = find.byType(ListView);

      expect(buttonFinder, findsOneWidget);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockDetailTVBloc.state)
          .thenReturn(TvDetailError('Error'));
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          WatchlistTvStatusState(isAddedWatchlistTv: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(TvRecommendationError('Error'));

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(
        id: testTvDetail.id,
      )));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });

  group('TV Page, Detail TV Widgets:', () {
    testWidgets(
        'watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockDetailTVBloc.state)
          .thenReturn(TvDetailHasData(testTvDetail));
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          WatchlistTvStatusState(isAddedWatchlistTv: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(TvRecommendationHasData(testTvList));

      await tester.pumpWidget(
          _makeTestableWidget(TvDetailPage(id: testTvDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockDetailTVBloc.state)
          .thenReturn(TvDetailHasData(testTvDetail));
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          WatchlistTvStatusState(isAddedWatchlistTv: true, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(TvRecommendationHasData(testTvList));

      await tester.pumpWidget(
          _makeTestableWidget(TvDetailPage(id: testTvDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}
