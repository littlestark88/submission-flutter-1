import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late SaveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlist(mockMovieRepository);
  });

  group('Movie Use Cases, Save Movie Watchlist:', () {
    test('should save movie to the repository', () async {
      // arrange
      when(() => mockMovieRepository.saveWatchlist(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      // act
      final result = await usecase.execute(testMovieDetail);
      // assert
      verify(() => mockMovieRepository.saveWatchlist(testMovieDetail));
      expect(result, const Right('Added to Watchlist'));
    });
  });
}
