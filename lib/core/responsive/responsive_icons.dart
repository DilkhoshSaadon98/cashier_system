/// Returns a responsive icon size based on the provided screen width.
///
/// This function adjusts the icon size according to the screen width
/// to ensure appropriate scaling across different devices.
///
/// - [width]: The width of the screen or container.
///
/// Returns the appropriate icon size in points.
double responsiveIconSize(double width) {
  // Define width breakpoints and corresponding icon sizes
  const double largeBreakpoint = 1000;
  const double mediumBreakpoint = 700;
  const double smallBreakpoint = 400;
  const double xSmallBreakpoint = 200;

  // Define icon sizes corresponding to the width breakpoints
  const double largeIconSize = 18;
  const double mediumIconSize = 15;
  const double smallIconSize = 13;
  const double xSmallIconSize = 10;
  const double defaultIconSize = 8;

  // Determine the icon size based on the width
  if (width > largeBreakpoint) {
    return largeIconSize;
  } else if (width > mediumBreakpoint) {
    return mediumIconSize;
  } else if (width > smallBreakpoint) {
    return smallIconSize;
  } else if (width > xSmallBreakpoint) {
    return xSmallIconSize;
  } else {
    return defaultIconSize;
  }
}
