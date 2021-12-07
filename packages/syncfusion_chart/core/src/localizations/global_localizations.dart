import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Defines the localized resource values used by the Syncfusion Widgets.
///
/// See also:
///
///  * [SfGlobalLocalizations], which provides localizations for many languages.
///
abstract class SfLocalizations {
  /// Label that is displayed when no date is selected in a calendar widget.
  /// This label is displayed under agenda section in month view.
  String get noSelectedDateCalendarLabel;

  /// Label that is displayed when there are no events for a
  /// selected date in a calendar widget.
  /// This label is displayed under agenda section in month view.
  String get noEventsCalendarLabel;

  /// A [LocalizationsDelegate] that uses [_DefaultLocalizations.load]
  /// to create an instance of this class.
  ///
  /// [MaterialApp] automatically adds this value to
  /// [MaterialApp.localizationsDelegates].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///     localizationsDelegates: [
  ///       SfGlobalLocalizations.delegate
  ///     ],
  ///     supportedLocales: const [
  ///       Locale('en'),
  ///       Locale('fr'),
  ///     ],
  ///     locale: const Locale('fr')
  ///   );
  /// }
  ///```
  static const LocalizationsDelegate<SfLocalizations> delegate =
      _SfLocalizationDelegates();

  /// The `SfLocalizations` from the closest [Localizations] instance
  /// that encloses the given context.
  ///
  /// This method is just a convenient shorthand for:
  ///Localizations.of(context, SfLocalizations).
  ///
  /// References to the localized resources defined by this class are typically
  /// written in terms of this method. For example:
  ///
  /// ```dart
  /// String label = SfLocalizations.of(context).noSelectedDateCalendarLabel,
  ///```
  ///
  static SfLocalizations of(BuildContext context) {
    return Localizations.of<SfLocalizations>(context, SfLocalizations) ??
        const _DefaultLocalizations();
  }
}

class _SfLocalizationDelegates extends LocalizationsDelegate<SfLocalizations> {
  const _SfLocalizationDelegates();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<SfLocalizations> load(Locale locale) =>
      _DefaultLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<SfLocalizations> old) => false;
}

/// US English strings for the Syncfusion widgets.
class _DefaultLocalizations implements SfLocalizations {
  const _DefaultLocalizations();

  @override
  String get noSelectedDateCalendarLabel => 'No selected date';

  @override
  String get noEventsCalendarLabel => 'No events';

  static Future<SfLocalizations> load(Locale locale) {
    return SynchronousFuture<SfLocalizations>(const _DefaultLocalizations());
  }

  //ignore: unused_field
  static const LocalizationsDelegate<SfLocalizations> delegate =
      _SfLocalizationDelegates();
}
