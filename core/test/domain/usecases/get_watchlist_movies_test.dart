import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetWatchlistMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlistMovies(mockMovieRepository);
  });

  group('Movie Use Cases, Get Movie Watchlist:', () {
    test('should get list of movies from the repository', () async {
      // arrange
      when(() => mockMovieRepository.getWatchlistMovies())
          .thenAnswer((_) async => Right(testMovieList));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(testMovieList));
    });
  });
}
