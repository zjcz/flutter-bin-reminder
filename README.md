# Bin Reminder Flutter App

A new Flutter project.


## Packages Used
- [sqlflite](https://pub.dev/packages/sqflite) Flutter SQLite implementation.  Used to store the data.  I also used the [sqflite ffi](https://pub.dev/packages/sqflite_common_ffi) package to allow sqflite to work on non mobile devices, and when running unit tests.
- [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) Font Awesome icons.  Used to illustrate the different bin types.
- [material_color_utilities](https://pub.dev/packages/material_color_utilities) Used to help provide better implementation of the Material Design 3 colour scheme. 
- [Jiffy](https://pub.dev/packages/jiffy) Jiffy is used to format dates.  I found this more powerful than the [intl](https://pub.dev/packages/intl) package.
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) This package is used to trigger notifications.
- [clock](https://pub.dev/packages/clock) This package allows use to mock the current date/time within the unit tests

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Design Decisions
### Edit Form Validation
I could have used the Form widget and the TextFormField to manage the validation of the form, but 
without the ability to validate the dropdown boxes I felt it was easier to write my own custom 
validation.  Form validation is available if I had used the DropDownButtonFormField rather than the 
newer DropDownMenu control, but then I would have lost features such as icons in the dropdown items. 
