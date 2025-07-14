
import 'dart:ui';

class StylesManager {
  TextStyle getTextStyle ( double fontSize,
      FontWeight fontWeight,
      Color color,) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );

}