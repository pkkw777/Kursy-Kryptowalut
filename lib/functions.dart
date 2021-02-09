import 'dart:ui';

getColor(String string) {
  if(string.contains(("-")))
    return hexToColor('#FF0000');
  else
    return hexToColor('#32CD32');
}

hexToColor(String color) {
  return new Color(int.parse(color.substring(1,7),radix: 16) + 0xFF000000);
}