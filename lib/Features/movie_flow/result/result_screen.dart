import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/Features/movie_flow/movie_flow_controller.dart';
import 'package:movie_app/Features/movie_flow/result/movie.dart';
import 'package:movie_app/core/widgets/primary_buttons.dart';
import 'package:movie_app/core/constants.dart';

class ResultScreen extends ConsumerWidget {
  ResultScreen({super.key});
  static route({bool fullscreenDialog = true}) => MaterialPageRoute(
      builder: (context) => ResultScreen(), fullscreenDialog: fullscreenDialog);

  final double movieHeight = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(movieFlowControllerProvider).movie.when(
        data: (movie) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    Stack(clipBehavior: Clip.none, children: [
                      CoverImage(movie: movie,),
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        bottom: -(movieHeight / 2),
                        child: MovieImageDetails(
                          movie: movie,
                          movieHeight: movieHeight,
                        ),
                      ),
                    ]),
                    SizedBox(height: movieHeight / 2),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        movie.overview,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                )),
                PrimaryButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'Find another movie'),
                const SizedBox(
                  height: KMediumSpacing,
                )
              ],
            ),
          );
        },
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        error: (e, s) {
          return const Text('Something went wrong on our end');
        });
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 298),
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent
            ],
          ).createShader(Rect.fromLTRB(0, 0, rect.right, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: Image.network(
          movie.backdropPath ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, e, s) {
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class MovieImageDetails extends ConsumerWidget {
  const MovieImageDetails(
      {super.key, required this.movieHeight, required this.movie});

  final double movieHeight;
  final Movie movie;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: movieHeight,
            child: Image.network(
              movie.posterPath ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, e, s) {
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(width: KMediumSpacing),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(movie.title, style: theme.textTheme.headline6),
              Text(movie.genresCommaSeparated,
                  style: theme.textTheme.bodyText2),
              Row(
                children: [
                  Text(
                    movie.voteAverage.toString(),
                    style: theme.textTheme.bodyText2?.copyWith(
                      color:
                          theme.textTheme.bodyText2?.color?.withOpacity(0.62),
                    ),
                  ),
                  const Icon(Icons.star_rounded, size: 20, color: Colors.amber)
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
