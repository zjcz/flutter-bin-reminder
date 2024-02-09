# Flutter Bin Reminder App

## 📱 Description
This application allows the user to enter the details about their bins (type, colour, etc) and the app will provide a notification to remind them to put them out for collection.

This sample application uses features such as local database storage, CRUD management, background services, navigation and unit testing.

Note: The application has only been tested on Android.

## 🔃 How It Works
The user enters details of their bin, and the next collection date.  This uses a standard listview 
to list the bins, and tapping a record allows the user to view or edit the details.  A background 
service will check for collection due (either today or tomorrow) and display a notification on the 
users device to remind them about the collection.

Once the collect date has passed, the background service will update the collection date to the next
future due date.

## 🖥️ Instructions
- First you will need to install flutter.  Follow this [Get Started](https://docs.flutter.dev/get-started/install) guide.

- Clone the repository
```bash
git clone https://github.com/zjcz/bin_reminder.git
```

- Open the project in your IDE, such as Android Studio or VS Code.

- Select your target device and run the app.  You may need to setup an emulator first, or configure to use a physical device.

## 🖊️ TODO
- background service to provide notifications when collections are due
- Update the icons used within the application
- Update the application icon

## 📦 Packages Used
- [sqlflite](https://pub.dev/packages/sqflite) Flutter SQLite implementation, used to store the data.  I also used the [sqflite ffi](https://pub.dev/packages/sqflite_common_ffi) package to allow sqflite to work on non mobile devices, and when running unit tests.
- [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) Font Awesome icons.  Used to illustrate the different bin types.
- [material_color_utilities](https://pub.dev/packages/material_color_utilities) Used to help provide better implementation of the Material Design 3 colour scheme. 
- [Jiffy](https://pub.dev/packages/jiffy) Jiffy is used to format dates.  I found this more powerful than the [intl](https://pub.dev/packages/intl) package.
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) This package is used to trigger notifications.
- [clock](https://pub.dev/packages/clock) This package allows use to mock the current date/time within the unit tests

## 🏗️ Design Decisions
This is the first flutter app I have developed and I have tried to follow standard practice where
possible.

### Edit Form Validation
I used the Form widget and the TextFormField to manage the validation of the form, but as I was 
using DropDownMenu controls rather than the DropDownButton I had to manage the validation of the 
dropdowns manually. If I had used the DropDownButtonFormField rather than the newer DropDownMenu 
control I would have lost features such as icons in the dropdown items. 
