double responsivefontSize(double width) {
  double fontSize = 0.0;
  if (width > 1000) {
    fontSize = 16;
  } else if (width > 700) {
    fontSize = 14;
  } else if (width > 400) {
    fontSize = 12;
  } else if (width > 200) {
    fontSize = 10;
  } else {
    fontSize = 8;
  }
  return fontSize;
}
