import 'package:flutter/material.dart';

class FoodRatingWidget extends StatelessWidget {
  final int rating;
  const FoodRatingWidget({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}