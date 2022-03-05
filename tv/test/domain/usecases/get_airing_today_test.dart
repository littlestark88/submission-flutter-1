import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_airing_today_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late GetAiringTodayTv usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetAiringTodayTv(repository);
  });
  final tTV = <Tv>[];

  group('TV Use Cases, Get TV Airing Today:', () {
    test(
        'should get list on the air of tv shows from the repository when execute function is called',
        () async {
      // arrange
      when(() => repository.getAiringTodayTv())
          .thenAnswer((_) async => Right(tTV));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTV));
    });
  });
}
