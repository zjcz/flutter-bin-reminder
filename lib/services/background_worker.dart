import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bin_reminder/helpers/date_helper.dart';
import 'package:bin_reminder/services/database_service.dart';
import 'package:bin_reminder/models/bin.dart';
import 'package:bin_reminder/services/notification_service.dart';

class BackgroundWorker {
  static const backgroundWorkerUniqueName =
      "dev.jonclarke.bin_reminder.backgroundWorker";

  static const backgroundWorkerTaskKey =
      "dev.jonclarke.bin_reminder.background.scheduledTask";

  Future<void> cleanUpCollectionDates() async {
    DatabaseService ds = DatabaseService();
    await ds.updatePastCollectionDates();
  }

  Future<void> sendNotifications() async {
    DatabaseService ds = DatabaseService();
    NotificationService ns = NotificationService();

    List<Bin> bins = await ds.listDueBins();
    for (Bin b in bins) {
      // collection is due, send a notification
      await ns.showNotification(
          title: 'Bin Reminder',
          body:
              '${b.name} is due ${DateHelper.getFormattedNextCollectionDate(b.collectionDate)}');
    }
  }

  /// background worker task
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      const dateLastRunSharedPrefSettingName = "bgw_lastchecked";

      switch (task) {
        case backgroundWorkerTaskKey:
          final prefs = await SharedPreferences.getInstance();
          String? dateLastRunSetting =
              prefs.getString(dateLastRunSharedPrefSettingName);

          DateTime dateLastRun = (dateLastRunSetting == null
              ? DateHelper.getToday()
              : DateTime.parse(dateLastRunSetting));

          if (dateLastRun.isBefore(DateHelper.getToday())) {
            // scheduled job last ran yesterday.  Run it now
            BackgroundWorker dw = BackgroundWorker();
            await dw.cleanUpCollectionDates();
            await dw.sendNotifications();
          }

          prefs.setString(dateLastRunSharedPrefSettingName,
              DateHelper.getToday().toIso8601String());
          break;
      }

      return Future.value(true);
    });
  }
}
