import 'package:flutter/material.dart';

import 'breakpoints.dart';
import 'device_type.dart';

extension ResponsiveExtension on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  Orientation get orientation => MediaQuery.orientationOf(this);

  bool get isPortrait => orientation == Orientation.portrait;

  bool get isLandscape => orientation == Orientation.landscape;

  DeviceType get deviceType {
    if (screenWidth < Breakpoints.phone) {
      return DeviceType.phone;
    }

    if (screenWidth < Breakpoints.tablet) {
      return DeviceType.tablet;
    }

    return DeviceType.desktop;
  }

  bool get isPhone => deviceType == DeviceType.phone;

  bool get isTablet => deviceType == DeviceType.tablet;

  bool get isDesktop => deviceType == DeviceType.desktop;

  bool get useBottomNavigation => isPhone;
}