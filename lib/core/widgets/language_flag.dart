import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_tasks/core/config/app_config.dart';

class LanguageFlag extends StatelessWidget {
  const LanguageFlag({super.key, required this.languageCode, this.height = 24});

  final String languageCode;
  final double height;

  @override
  Widget build(BuildContext context) {
    final asset = AppConfig.languageFlags[languageCode];
    final width = height * 4 / 3;

    if (asset == null) return SizedBox(width: width, height: height);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}
