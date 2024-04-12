import 'package:flutter/cupertino.dart';

class AppColors {
  static Color primary = const Color(0xFF39C61C);
  static LinearGradient buttonGradient = const LinearGradient(
    colors: [
      Color(0xFF39C61C),
      Color(0xFF136F00),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static LinearGradient headerGradient = LinearGradient(
    colors: [
      const Color(0xFF000000).withOpacity(0.675),
      const Color(0xFF000000).withOpacity(0.9),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static LinearGradient cardGradient = LinearGradient(
    colors: [
      const Color(0xFF000000).withOpacity(0.378),
      const Color(0xFF000000).withOpacity(0.9),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}