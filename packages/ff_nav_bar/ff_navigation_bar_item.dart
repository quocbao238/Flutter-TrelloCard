import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ff_navigation_bar_theme.dart';

// This class has mutable instance properties as they are used to store
// calculated values required by multiple build functions but not known
// (or required to be specified) at creation of instance parameters.
// For example, a color attribute will be modified depending on whether
// the item is selected or not.
// They are also used to store values retrieved from a Provider allowing
// properties to be communicated from the navigation bar to the individual
// items of the bar.

// ignore: must_be_immutable
class FFNavigationBarItem extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Duration animationDuration;
  Color selectedBackgroundColor;
  int index;
  int selectedIndex;
  FFNavigationBarTheme theme;
  double itemWidth;

  void setIndex(int index) {
    this.index = index;
  }

  Color _getDerivedBorderColor() {
    return theme.selectedItemBorderColor ?? theme.barBackgroundColor;
  }

  Color _getBorderColor(bool isOn) {
    return isOn ? _getDerivedBorderColor() : Colors.white;
  }

  bool _isItemSelected() {
    return index == selectedIndex;
  }

  static const kDefaultAnimationDuration = Duration(milliseconds: 1500);

  FFNavigationBarItem({
    Key key,
    this.label,
    this.itemWidth = 60,
    this.iconData,
    this.animationDuration = kDefaultAnimationDuration,
  }) : super(key: key);

  Widget _makeLabel(String label) {
    bool isSelected = _isItemSelected();
    return Center(
      child: Text(label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isSelected
              ? theme.selectedItemTextStyle
              : theme.unselectedItemTextStyle),
    );
  }

  Widget _makeIconArea(double itemWidth, IconData iconData) {
    bool isSelected = _isItemSelected();
    double radius = itemWidth / 2;
    double innerBoxSize = itemWidth - 8;
    double innerRadius = (itemWidth - 8) / 2 - 4;
    // return Container(
    //   width: itemWidth,
    //   height: itemWidth,
    //   decoration: BoxDecoration(
    //       color: _getBorderColor(isSelected), shape: BoxShape.circle),
    //   child: SizedBox(
    //     width: innerBoxSize,
    //     height: isSelected ? innerBoxSize : innerBoxSize / 2,

    //     // decoration: BoxDecoration(
    //     //   shape: BoxShape.circle,
    //     // ),
    //     child: Container(
    //       width: innerRadius * 2,
    //       color: isSelected
    //           ? selectedBackgroundColor ?? theme.selectedItemBackgroundColor
    //           : theme.unselectedItemBackgroundColor,
    //       child: _makeIcon(iconData, isSelected),
    //     ),
    //   ),
    // );

    return Container(
      color: Colors.transparent,
      child: CircleAvatar(
        radius: isSelected ? radius : radius * 0.7,
        backgroundColor: _getBorderColor(isSelected),
        child: SizedBox(
          width: innerBoxSize,
          height: isSelected ? innerBoxSize : innerBoxSize / 2,
          child: isSelected
              ? CircleAvatar(
                  foregroundColor: Colors.red,
                  radius: innerRadius,
                  backgroundColor: isSelected
                      ? theme.selectedItemBackgroundColor
                      : Colors.white,
                  child:
                      // Icon(Icons.ac_unit)
                      _makeIcon(iconData, isSelected),
                )
              : _makeIcon(iconData, isSelected),
        ),
      ),
    );
  }

  Widget _makeIcon(IconData iconData, bool isSelected) {
    return Icon(
      iconData,
      color: isSelected
          ? theme.selectedItemIconColor
          : theme.unselectedItemIconColor,
    );
  }

  Widget _makeShadow() {
    bool isSelected = _isItemSelected();
    double height = isSelected ? 4 : 0;
    double width = isSelected ? itemWidth + 6 : 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(itemWidth / 2, 2)),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<FFNavigationBarTheme>(context);
    itemWidth = theme.itemWidth;
    selectedIndex = Provider.of<int>(context);
    selectedBackgroundColor =
        selectedBackgroundColor ?? theme.selectedItemBackgroundColor;
    bool isSelected = _isItemSelected();
    double itemHeight = itemWidth - 20;
    double topOffset = isSelected ? -30 : 0;
    double iconTopSpacer = isSelected ? 0 : 2;
    Widget labelWidget = _makeLabel(label);
    Widget iconAreaWidget = _makeIconArea(60, iconData);
    return AnimatedContainer(
      width: itemWidth,
      height: double.maxFinite,
      duration: animationDuration,
      child: SizedBox(
        width: itemWidth,
        height: itemHeight,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: topOffset,
              left: -itemWidth / 2,
              right: -itemWidth / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: iconTopSpacer),
                  iconAreaWidget,
                  if (isSelected)
                    Padding(
                        padding: EdgeInsets.only(
                            top: 4, left: itemWidth / 2, right: itemWidth / 2),
                        child: labelWidget),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
