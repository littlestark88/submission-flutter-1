import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetTopRatedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  group('Movie Use Cases, Get Movie Top Rated:', () {
    test('should get list of movies from repository', () async {
      // arrange
      when(() => mockMovieRepository.getTopRatedMovies())
          .thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tMovies));
    });
  });
}
