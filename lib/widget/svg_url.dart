import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  final double height;
  final double width;
  final String url;

  const SvgImage(
      {required this.url,
      super.key,
      required this.height,
      this.width = 100.00});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      url,
      placeholderBuilder: (BuildContext context) => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: Color(0xffffa89e),
        ),
      ),
      height: height,
      width: width,
      fit: BoxFit.fill,
    );
  }
}
