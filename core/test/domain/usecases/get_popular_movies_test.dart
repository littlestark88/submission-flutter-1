import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRpository);
  });

  final tMovies = <Movie>[];

  group('Movie Use Cases, Get Movie Popular:', () {
    test(
        'should get list of movies from the repository when execute function is called',
        () async {
      // arrange
      when(() => mockMovieRpository.getPopularMovies())
          .thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tMovies));
    });
  });
}
