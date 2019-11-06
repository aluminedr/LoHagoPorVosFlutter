import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 

class Valorar extends StatefulWidget{
  final index;
  final idPersonaLogeada;
  Valorar(this.index, this.idPersonaLogeada);

  @override
  _ValorarState createState() => _ValorarState();
}

class _ValorarState extends State<Valorar> {

  @override
  Widget build(BuildContext context) {
    var rating;
    return Scaffold(
      body:
        Container(
          child: SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  rating = v;
                  setState(() {});
                },
                starCount: 5,
                rating: rating,
            size: 40.0,
            color: Colors.green,
            borderColor: Colors.purple,
            spacing:0.0
          ),
        ),
    );
  }
}