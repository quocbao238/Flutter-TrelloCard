import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion maps widgets.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfMapsTheme(
///       data: SfMapsThemeData(
///         brightness: Brightness.dark,
///       ),
///       child: SfMaps()
///     ),
///   );
/// }
/// ```
class SfMapsTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const SfMapsTheme({Key key, this.data, this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant maps widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfMapsTheme(
  ///       data: SfMapsThemeData(
  ///         brightness: Brightness.dark,
  ///       ),
  ///       child: SfMaps()
  ///     ),
  ///   );
  /// }
  /// ```
  final SfMapsThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfMapsTheme(
  ///       data: SfMapsThemeData(
  ///         brightness: Brightness.dark,
  ///       ),
  ///       child: SfMaps()
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfMapsTheme] instance
  /// that encloses the given context.
  ///
  /// Defaults to [SfThemeData.mapsThemeData] if there is no
  /// [SfMapsTheme] in the given build context.
  static SfMapsThemeData of(BuildContext context) {
    final SfMapsTheme mapsTheme =
        context.dependOnInheritedWidgetOfExactType<SfMapsTheme>();
    return mapsTheme?.data ?? SfTheme.of(context).mapsThemeData;
  }

  @override
  bool updateShouldNotify(SfMapsTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfMapsTheme ancestorTheme =
        context.findAncestorWidgetOfExactType<SfMapsTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfMapsTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfMapsTheme]. Use this class
/// to configure a [SfMapsTheme] widget, or to set the
/// [SfThemeData.mapsThemeData] for a [SfTheme] widget.
///
/// To obtain the current theme, use [SfMapsTheme.of].
///
/// The maps elements are,
///
/// * The "data labels", to provide information to users about the respective
/// shape.
/// * The "markers", which denotes a location with built-in symbols and allows
/// displaying custom widgets at a specific latitude and longitude on a map.
/// * The "bubbles", which adds information to shapes such as population
/// density, number of users, and more. Bubbles can be rendered in different
/// colors and sizes based on the data values of their assigned shape.
/// * The "legend", to provide clear information on the data plotted in the map.
/// You can use the legend toggling feature to visualize only the shapes to
/// which needs to be visualized.
/// * The "color mapping", to categorize the shapes on a map by customizing
/// their color based on the underlying value. It is possible to set the shape
/// color for a specific value or for a range of values.
/// * The "tooltip", to display additional information about shapes and bubbles
/// using the customizable tooltip on a map.
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the maps.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfMapsTheme(
///       data: SfMapsThemeData(
///         brightness: Brightness.dark,
///       ),
///       child: SfMaps()
///     ),
///   );
/// }
/// ```
class SfMapsThemeData with Diagnosticable {
  /// Returns a new instance of [SfMapsThemeData.raw] for the given values.
  ///
  /// If any of the values are null, the default values will be set.
  factory SfMapsThemeData(
      {Brightness brightness,
      TextStyle titleTextStyle,
      Color layerColor,
      Color layerStrokeColor,
      double layerStrokeWidth,
      TextStyle legendTextStyle,
      Color markerIconColor,
      Color markerIconStrokeColor,
      double markerIconStrokeWidth,
      TextStyle dataLabelTextStyle,
      Color bubbleColor,
      Color bubbleStrokeColor,
      double bubbleStrokeWidth,
      Color selectionColor,
      Color selectionStrokeColor,
      double selectionStrokeWidth,
      TextStyle tooltipTextStyle,
      Color tooltipColor,
      Color tooltipStrokeColor,
      double tooltipStrokeWidth,
      Color toggledShapeColor,
      Color toggledShapeStrokeColor,
      double toggledShapeStrokeWidth}) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    layerColor ??= isLight
        ? const Color.fromRGBO(224, 224, 224, 1)
        : const Color.fromRGBO(97, 97, 97, 1);
    layerStrokeColor ??= isLight
        ? const Color.fromRGBO(158, 158, 158, 0.5)
        : const Color.fromRGBO(224, 224, 224, 0.5);
    layerStrokeWidth ??= 1.0;
    markerIconColor ??= isLight
        ? const Color.fromRGBO(98, 0, 238, 1)
        : const Color.fromRGBO(187, 134, 252, 1);
    markerIconStrokeWidth ??= 1.0;
    bubbleColor ??= isLight
        ? const Color.fromRGBO(98, 0, 238, 0.5)
        : const Color.fromRGBO(187, 134, 252, 0.8);
    bubbleStrokeWidth ??= 1.0;
    selectionColor ??= isLight
        ? const Color.fromRGBO(117, 117, 117, 1)
        : const Color.fromRGBO(224, 224, 224, 1);
    selectionStrokeColor ??= isLight
        ? const Color.fromRGBO(158, 158, 158, 1)
        : const Color.fromRGBO(97, 97, 97, 1);
    selectionStrokeWidth ??= 0.5;
    tooltipColor ??= isLight
        ? const Color.fromRGBO(117, 117, 117, 1)
        : const Color.fromRGBO(245, 245, 245, 1);
    tooltipStrokeWidth ??= 1.0;
    toggledShapeColor ??= isLight
        ? const Color.fromRGBO(245, 245, 245, 1)
        : const Color.fromRGBO(66, 66, 66, 1);
    toggledShapeStrokeColor ??= isLight
        ? const Color.fromRGBO(158, 158, 158, 1)
        : const Color.fromRGBO(97, 97, 97, 1);

    return SfMapsThemeData.raw(
        brightness: brightness,
        titleTextStyle: titleTextStyle,
        layerColor: layerColor,
        layerStrokeColor: layerStrokeColor,
        legendTextStyle: legendTextStyle,
        markerIconColor: markerIconColor,
        markerIconStrokeColor: markerIconStrokeColor,
        dataLabelTextStyle: dataLabelTextStyle,
        bubbleColor: bubbleColor,
        bubbleStrokeColor: bubbleStrokeColor,
        bubbleStrokeWidth: bubbleStrokeWidth,
        selectionColor: selectionColor,
        selectionStrokeColor: selectionStrokeColor,
        tooltipTextStyle: tooltipTextStyle,
        tooltipColor: tooltipColor,
        tooltipStrokeColor: tooltipStrokeColor,
        tooltipStrokeWidth: tooltipStrokeWidth,
        selectionStrokeWidth: selectionStrokeWidth,
        layerStrokeWidth: layerStrokeWidth,
        markerIconStrokeWidth: markerIconStrokeWidth,
        toggledShapeColor: toggledShapeColor,
        toggledShapeStrokeColor: toggledShapeStrokeColor,
        toggledShapeStrokeWidth: toggledShapeStrokeWidth);
  }

  /// Create a [SfMapsThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfMapsThemeData] constructor.
  const SfMapsThemeData.raw(
      {@required this.brightness,
      @required this.titleTextStyle,
      @required this.layerColor,
      @required this.layerStrokeColor,
      @required this.layerStrokeWidth,
      @required this.legendTextStyle,
      @required this.markerIconColor,
      @required this.markerIconStrokeColor,
      @required this.markerIconStrokeWidth,
      @required this.dataLabelTextStyle,
      @required this.bubbleColor,
      @required this.bubbleStrokeColor,
      @required this.bubbleStrokeWidth,
      @required this.selectionColor,
      @required this.selectionStrokeColor,
      @required this.selectionStrokeWidth,
      @required this.tooltipTextStyle,
      @required this.tooltipColor,
      @required this.tooltipStrokeColor,
      @required this.tooltipStrokeWidth,
      @required this.toggledShapeColor,
      @required this.toggledShapeStrokeColor,
      @required this.toggledShapeStrokeWidth});

  /// The brightness of the overall theme of the
  /// application for the maps widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// maps widgets will be applied.
  ///
  /// Also refer [Brightness].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              brightness: Brightness.dark
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Brightness brightness;

  /// Specifies the text style of the title.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              titleTextStyle: TextStyle(
  ///               decoration: TextDecoration.underline, fontSize: 18)
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final TextStyle titleTextStyle;

  /// Specifies the fill color for maps layer.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              layerColor: Colors.red[400]
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color layerColor;

  /// Specifies the stroke color for maps layer.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              layerStrokeColor: Colors.red
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color layerStrokeColor;

  /// Specifies the stroke width for maps layer.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              layerStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double layerStrokeWidth;

  /// Specifies the text style of the legend.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              legendTextStyle: TextStyle(decoration:
  ///              TextDecoration.underline)
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final TextStyle legendTextStyle;

  /// Specifies the fill color for marker icon.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              markerIconColor: Colors.green[400]
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color markerIconColor;

  /// Specifies the stroke color for marker icon.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              markerIconStrokeColor: Colors.green[900]
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color markerIconStrokeColor;

  /// Specifies the stroke width for marker icon.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              markerIconStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double markerIconStrokeWidth;

  /// Specifies the TextStyle for data label.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              dataLabelTextStyle: TextStyle(color: Colors.red)
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final TextStyle dataLabelTextStyle;

  /// Specifies the fill color for bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleColor: Colors.blue
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color bubbleColor;

  /// Specifies the stroke color for bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleStrokeColor: Colors.indigo
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color bubbleStrokeColor;

  /// Specifies the stroke width for bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleStrokeWidth: 3
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double bubbleStrokeWidth;

  /// Specifies the fill color for selected shape.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              selectionColor: Colors.indigo[200]
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color selectionColor;

  /// Specifies the stroke color for selected shape.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              selectionStrokeColor: Colors.indigo
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color selectionStrokeColor;

  /// Specifies the stroke width for selected shape.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              selectionStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double selectionStrokeWidth;

  /// Specifies the textStyle for tooltip text.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              tooltipTextStyle: TextStyle(color: Colors.black,
  ///              fontWeight: FontWeight.bold)
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final TextStyle tooltipTextStyle;

  /// Specifies the fill color for tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              tooltipColor: Colors.tealAccent
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color tooltipColor;

  /// Specifies the stroke color for tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              tooltipStrokeColor: Colors.teal
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color tooltipStrokeColor;

  /// Specifies the stroke width for tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              tooltipStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double tooltipStrokeWidth;

  /// Specifies the color of the toggled shape
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              toggledShapeColor: Colors.yellow
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color toggledShapeColor;

  /// Specifies the stroke color of the toggled shape
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              toggledShapeStrokeColor: Colors.green
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color toggledShapeStrokeColor;

  /// Specifies the stroke width of the toggled shape
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              toggledShapeStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double toggledShapeStrokeWidth;

  /// Creates a copy of this theme but with the given
  /// fields replaced with the new values.
  SfMapsThemeData copyWith({
    Brightness brightness,
    TextStyle titleTextStyle,
    Color layerColor,
    Color layerStrokeColor,
    double layerStrokeWidth,
    TextStyle legendTextStyle,
    Color markerIconColor,
    Color markerIconStrokeColor,
    double markerIconStrokeWidth,
    TextStyle dataLabelTextStyle,
    Color bubbleColor,
    Color bubbleStrokeColor,
    double bubbleStrokeWidth,
    Color selectionColor,
    Color selectionStrokeColor,
    double selectionStrokeWidth,
    TextStyle tooltipTextStyle,
    Color tooltipColor,
    Color tooltipStrokeColor,
    double tooltipStrokeWidth,
    Color toggledShapeColor,
    Color toggledShapeStrokeColor,
    double toggledShapeStrokeWidth,
  }) {
    return SfMapsThemeData.raw(
      brightness: brightness ?? this.brightness,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      layerColor: layerColor ?? this.layerColor,
      layerStrokeColor: layerStrokeColor ?? this.layerStrokeColor,
      layerStrokeWidth: layerStrokeWidth ?? this.layerStrokeWidth,
      legendTextStyle: legendTextStyle ?? this.legendTextStyle,
      markerIconColor: markerIconColor ?? this.markerIconColor,
      markerIconStrokeColor:
          markerIconStrokeColor ?? this.markerIconStrokeColor,
      markerIconStrokeWidth:
          markerIconStrokeWidth ?? this.markerIconStrokeWidth,
      dataLabelTextStyle: dataLabelTextStyle ?? this.dataLabelTextStyle,
      bubbleColor: bubbleColor ?? this.bubbleColor,
      bubbleStrokeColor: bubbleStrokeColor ?? this.bubbleStrokeColor,
      bubbleStrokeWidth: bubbleStrokeWidth ?? this.bubbleStrokeWidth,
      selectionColor: selectionColor ?? this.selectionColor,
      selectionStrokeColor: selectionStrokeColor ?? this.selectionStrokeColor,
      selectionStrokeWidth: selectionStrokeWidth ?? this.selectionStrokeWidth,
      tooltipTextStyle: tooltipTextStyle ?? this.tooltipTextStyle,
      tooltipColor: tooltipColor ?? this.tooltipColor,
      tooltipStrokeColor: tooltipStrokeColor ?? this.tooltipStrokeColor,
      tooltipStrokeWidth: tooltipStrokeWidth ?? this.tooltipStrokeWidth,
      toggledShapeColor: toggledShapeColor ?? this.toggledShapeColor,
      toggledShapeStrokeColor:
          toggledShapeStrokeColor ?? this.toggledShapeStrokeColor,
      toggledShapeStrokeWidth:
          toggledShapeStrokeWidth ?? this.toggledShapeStrokeWidth,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  static SfMapsThemeData lerp(SfMapsThemeData a, SfMapsThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) {
      return null;
    }
    return SfMapsThemeData(
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      layerColor: Color.lerp(a.layerColor, b.layerColor, t),
      layerStrokeColor: Color.lerp(a.layerStrokeColor, b.layerStrokeColor, t),
      layerStrokeWidth: lerpDouble(a.layerStrokeWidth, b.layerStrokeWidth, t),
      legendTextStyle: TextStyle.lerp(a.legendTextStyle, b.legendTextStyle, t),
      markerIconColor: Color.lerp(a.markerIconColor, b.markerIconColor, t),
      markerIconStrokeColor:
          Color.lerp(a.markerIconStrokeColor, b.markerIconStrokeColor, t),
      markerIconStrokeWidth:
          lerpDouble(a.markerIconStrokeWidth, b.markerIconStrokeWidth, t),
      dataLabelTextStyle:
          TextStyle.lerp(a.dataLabelTextStyle, b.dataLabelTextStyle, t),
      bubbleColor: Color.lerp(a.bubbleColor, b.bubbleColor, t),
      bubbleStrokeColor:
          Color.lerp(a.bubbleStrokeColor, b.bubbleStrokeColor, t),
      bubbleStrokeWidth:
          lerpDouble(a.bubbleStrokeWidth, b.bubbleStrokeWidth, t),
      selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t),
      selectionStrokeColor:
          Color.lerp(a.selectionStrokeColor, b.selectionStrokeColor, t),
      selectionStrokeWidth:
          lerpDouble(a.selectionStrokeWidth, b.selectionStrokeWidth, t),
      tooltipTextStyle:
          TextStyle.lerp(a.tooltipTextStyle, b.tooltipTextStyle, t),
      tooltipColor: Color.lerp(a.tooltipColor, b.tooltipColor, t),
      tooltipStrokeColor:
          Color.lerp(a.tooltipStrokeColor, b.tooltipStrokeColor, t),
      tooltipStrokeWidth:
          lerpDouble(a.tooltipStrokeWidth, b.tooltipStrokeWidth, t),
      toggledShapeColor:
          Color.lerp(a.toggledShapeColor, b.toggledShapeColor, t),
      toggledShapeStrokeColor:
          Color.lerp(a.toggledShapeStrokeColor, b.toggledShapeStrokeColor, t),
      toggledShapeStrokeWidth:
          lerpDouble(a.toggledShapeStrokeWidth, b.toggledShapeStrokeWidth, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final SfMapsThemeData typedOther = other;
    return typedOther.titleTextStyle == titleTextStyle &&
        typedOther.layerColor == layerColor &&
        typedOther.layerStrokeColor == layerStrokeColor &&
        typedOther.layerStrokeWidth == layerStrokeWidth &&
        typedOther.legendTextStyle == legendTextStyle &&
        typedOther.markerIconColor == markerIconColor &&
        typedOther.markerIconStrokeColor == markerIconStrokeColor &&
        typedOther.markerIconStrokeWidth == markerIconStrokeWidth &&
        typedOther.dataLabelTextStyle == dataLabelTextStyle &&
        typedOther.bubbleColor == bubbleColor &&
        typedOther.bubbleStrokeColor == bubbleStrokeColor &&
        typedOther.bubbleStrokeWidth == bubbleStrokeWidth &&
        typedOther.selectionColor == selectionColor &&
        typedOther.selectionStrokeColor == selectionStrokeColor &&
        typedOther.selectionStrokeWidth == selectionStrokeWidth &&
        typedOther.tooltipTextStyle == tooltipTextStyle &&
        typedOther.tooltipColor == tooltipColor &&
        typedOther.tooltipStrokeColor == tooltipStrokeColor &&
        typedOther.tooltipStrokeWidth == tooltipStrokeWidth &&
        typedOther.toggledShapeColor == toggledShapeColor &&
        typedOther.toggledShapeStrokeColor == toggledShapeStrokeColor &&
        typedOther.toggledShapeStrokeWidth == toggledShapeStrokeWidth;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      titleTextStyle,
      layerColor,
      layerStrokeColor,
      layerStrokeWidth,
      legendTextStyle,
      markerIconColor,
      markerIconStrokeColor,
      markerIconStrokeWidth,
      dataLabelTextStyle,
      bubbleColor,
      bubbleStrokeColor,
      bubbleStrokeWidth,
      selectionColor,
      selectionStrokeColor,
      selectionStrokeWidth,
      tooltipTextStyle,
      tooltipColor,
      tooltipStrokeColor,
      tooltipStrokeWidth,
      toggledShapeColor,
      toggledShapeStrokeColor,
      toggledShapeStrokeWidth,
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfMapsThemeData defaultData = SfMapsThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(DiagnosticsProperty<TextStyle>(
        'titleTextStyle', titleTextStyle,
        defaultValue: defaultData.titleTextStyle));
    properties.add(ColorProperty('layerColor', layerColor,
        defaultValue: defaultData.layerColor));
    properties.add(ColorProperty('layerStrokeColor', layerStrokeColor,
        defaultValue: defaultData.layerStrokeColor));
    properties.add(DoubleProperty('layerStrokeWidth', layerStrokeWidth,
        defaultValue: defaultData.layerStrokeWidth));
    properties.add(DiagnosticsProperty<TextStyle>(
        'legendTextStyle', legendTextStyle,
        defaultValue: defaultData.legendTextStyle));
    properties.add(ColorProperty('markerIconColor', markerIconColor,
        defaultValue: defaultData.markerIconColor));
    properties.add(ColorProperty('markerIconStrokeColor', markerIconStrokeColor,
        defaultValue: defaultData.markerIconStrokeColor));
    properties.add(DoubleProperty(
        'markerIconStrokeWidth', markerIconStrokeWidth,
        defaultValue: defaultData.markerIconStrokeWidth));
    properties.add(DiagnosticsProperty<TextStyle>(
        'dataLabelTextStyle', dataLabelTextStyle,
        defaultValue: defaultData.dataLabelTextStyle));
    properties.add(ColorProperty('bubbleColor', bubbleColor,
        defaultValue: defaultData.bubbleColor));
    properties.add(ColorProperty('bubbleStrokeColor', bubbleStrokeColor,
        defaultValue: defaultData.bubbleStrokeColor));
    properties.add(DoubleProperty('bubbleStrokeWidth', bubbleStrokeWidth,
        defaultValue: defaultData.bubbleStrokeWidth));
    properties.add(ColorProperty('selectionColor', selectionColor,
        defaultValue: defaultData.selectionColor));
    properties.add(ColorProperty('selectionStrokeColor', selectionStrokeColor,
        defaultValue: defaultData.selectionStrokeColor));
    properties.add(DoubleProperty('selectionStrokeWidth', selectionStrokeWidth,
        defaultValue: defaultData.selectionStrokeWidth));
    properties.add(DiagnosticsProperty<TextStyle>(
        'tooltipTextStyle', tooltipTextStyle,
        defaultValue: defaultData.tooltipTextStyle));
    properties.add(ColorProperty('tooltipColor', tooltipColor,
        defaultValue: defaultData.tooltipColor));
    properties.add(ColorProperty('tooltipStrokeColor', tooltipStrokeColor,
        defaultValue: defaultData.tooltipStrokeColor));
    properties.add(DoubleProperty('tooltipStrokeWidth', tooltipStrokeWidth,
        defaultValue: defaultData.tooltipStrokeWidth));
    properties.add(ColorProperty('toggledShapeColor', toggledShapeColor,
        defaultValue: defaultData.toggledShapeColor));
    properties.add(ColorProperty(
        'toggledShapeStrokeColor', toggledShapeStrokeColor,
        defaultValue: defaultData.toggledShapeStrokeColor));
    properties.add(DoubleProperty(
        'toggledShapeStrokeWidth', toggledShapeStrokeWidth,
        defaultValue: defaultData.toggledShapeStrokeWidth));
  }
}
