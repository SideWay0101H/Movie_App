import 'dart:math';
import 'package:movie_app/Features/movie_flow/genre/genre.dart';
import 'package:movie_app/Features/movie_flow/movie_flow_repository.dart';
import 'package:movie_app/Features/movie_flow/result/movie.dart';
import 'package:riverpod/riverpod.dart';

final movieServiceprovider = Provider<MovieService>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return TMDBMovieService(movieRepository);
});

abstract class MovieService {
  Future<List<Genre>> getGenres();
  Future<Movie> getRecommandMovie(int rating, int yearsBack, List<Genre> genres,
      [DateTime? yearsBackFormDate]);
}

class TMDBMovieService implements MovieService {
  TMDBMovieService(this._movieRepository);
  final MovieRepository _movieRepository;

  @override
  Future<List<Genre>> getGenres() async {
    final genreEntities = await _movieRepository.getMovieGenres();
    final genres = genreEntities.map((e) => Genre.formEntity(e)).toList();
    return genres;
  }

  @override
  Future<Movie> getRecommandMovie(int rating, int yearsBack, List<Genre> genres,
      [DateTime? yearsBackFormDate]) async {
    final date = yearsBackFormDate ?? DateTime.now();
    final year = date.year - yearsBack;
    final genreIds = genres.map((e) => e.id).toList().join(',');
    final movieEntities = await _movieRepository.getRecommandMovies(
        rating.toDouble(), '$year-01-01', genreIds);
    final movies =
        movieEntities.map((e) => Movie.formEntity(e, genres)).toList();

    final rnd = Random();
    final randomMovie = movies[rnd.nextInt(movies.length)];
    return randomMovie;
  }
  

}
