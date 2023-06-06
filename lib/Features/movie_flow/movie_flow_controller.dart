import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/Features/movie_flow/genre/genre.dart';
import 'package:movie_app/Features/movie_flow/movie_flow_state.dart';
import 'package:movie_app/Features/movie_flow/movie_service.dart';
import 'package:movie_app/Features/movie_flow/result/movie.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
        (ref) {
  return MovieFlowController(
    MovieFlowState(
        pageController: PageController(),
        movie: AsyncValue.data(Movie.initial()),
        genres: const AsyncValue.data([])),
    ref.watch(movieServiceprovider),
  );
});

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(MovieFlowState state, this._movieService) : super(state) {
    loadGenres();
  }
  final MovieService _movieService;

  Future<void> loadGenres() async {
    state = state.copywith(genres: const AsyncValue.loading());
    final result = await _movieService.getGenres();

    state = state.copywith(genres: AsyncValue.data(result));
  }

  Future<void> getRecommandMovie() async {
    state = state.copywith(movie: const AsyncValue.loading());
    final selectedGenres = state.genres.asData?.value
            .where((e) => e.isSelected == true)
            .toList(growable: false) ??
        [];
    final result = await _movieService.getRecommandMovie(
        state.rating, state.yearsBack, selectedGenres);

    state = state.copywith(movie: AsyncValue.data(result));
  }

  void toggleSelected(Genre genre) {
    state = state.copywith(
      genres: AsyncValue.data([
        for (final oldGenre in state.genres.asData!.value)
          if (oldGenre == genre) oldGenre.toggleSelected() else oldGenre
      ]),
    );
  }

  void updateRating(int updateRating) {
    state = state.copywith(rating: updateRating);
  }

  void updateYearBack(int updateYearBack) {
    state = state.copywith(yearsBack: updateYearBack);
  }

  void nextPage() {
    if (state.pageController.page! >= 1) {
      if (!state.genres.asData !.value
          .any((e) => e.isSelected == true)) {
        return;
      }
    }
    state.pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic);
  }

  void previousPage() {
    state.pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}
