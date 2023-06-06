import 'package:flutter/material.dart';
import 'package:movie_app/Features/movie_flow/genre/genre.dart';
import 'package:movie_app/core/constants.dart';


class ListCard extends StatelessWidget {
  const ListCard({super.key,required this.onTap,required this.genre});
  final Genre genre;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Material(
        color: genre.isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(kBorderRadius),
          onTap: onTap,
          child: Container(
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
            child: Text(
              genre.name,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
