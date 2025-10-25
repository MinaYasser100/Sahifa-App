import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';

class DetailsVideoPlayButton extends StatelessWidget {
  const DetailsVideoPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: FadeIn(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: ColorsTheme().primaryColor.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorsTheme().blackColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              FontAwesomeIcons.play,
              color: ColorsTheme().whiteColor.withValues(alpha: 0.7),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
