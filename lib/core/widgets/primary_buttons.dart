import 'package:flutter/material.dart';
import 'package:movie_app/core/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onPressed,
    required this.text,
    this.isLoading =false,
    this.width = double.infinity,
    super.key});

  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius / 2)
          )
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(isLoading)
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              )
              else
            Text(
              text,
              style: Theme.of(context).textTheme.button,
            )
          ],
        )),
    );
  }
}
