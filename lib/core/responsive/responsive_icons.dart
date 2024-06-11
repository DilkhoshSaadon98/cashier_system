double responsiveIconSize(double width) {
  double iconSize = 0.0;
  if (width > 1000) {
    iconSize = 18;
  } else if (width > 700) {
    iconSize = 15;
  } else if (width > 400) {
    iconSize = 13;
  } else if (width > 200) {
    iconSize = 10;
  } else {
    iconSize = 8;
  }
  return iconSize;
}
