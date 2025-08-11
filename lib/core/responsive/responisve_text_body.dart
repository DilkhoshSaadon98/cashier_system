/// Returns a responsive font size based on the provided screen width.
///
/// This function adjusts the font size according to the screen width
/// to ensure readability across different devices.
///
/// - [width]: The width of the screen or container.
///
/// Returns the appropriate font size in points.
double responsiveFontSize(double width) {
  // Define width breakpoints and corresponding font sizes
  const double largeBreakpoint = 1000;
  const double mediumBreakpoint = 700;
  const double smallBreakpoint = 400;
  const double xSmallBreakpoint = 200;

  // Define font sizes corresponding to the width breakpoints
  const double largeFontSize = 16;
  const double mediumFontSize = 14;
  const double smallFontSize = 12;
  const double xSmallFontSize = 10;
  const double defaultFontSize = 8;

  // Determine the font size based on the width
  if (width > largeBreakpoint) {
    return largeFontSize;
  } else if (width > mediumBreakpoint) {
    return mediumFontSize;
  } else if (width > smallBreakpoint) {
    return smallFontSize;
  } else if (width > xSmallBreakpoint) {
    return xSmallFontSize;
  } else {
    return defaultFontSize;
  }
}
