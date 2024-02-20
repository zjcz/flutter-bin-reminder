import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bin_reminder/helpers/date_helper.dart';
import 'package:bin_reminder/services/database_service.dart';
import 'package:bin_reminder/models/bin.dart';
import 'package:bin_reminder/services/notification_service.dart';
import 'package:logger/logger.dart';

class BackgroundWorker {
  static const backgroundWorkerUniqueName =
      "dev.jonclarke.bin_reminder.backgroundWorker";

  static const backgroundWorkerTaskKey =
      "dev.jonclarke.bin_reminder.background.scheduledTask";

  final Logger _logger = Logger();

  Future<void> cleanUpCollectionDates() async {
    _logger.d('Clean up collection dates');

    DatabaseService ds = DatabaseService();
    await ds.updatePastCollectionDates();
  }

  Future<void> sendNotifications() async {
    _logger.d('Send notifications');

    DatabaseService ds = DatabaseService();
    NotificationService ns = NotificationService();

    List<Bin> bins = await ds.listDueBins();
    _logger.d('${bins.length} bins found with collections due');

    for (Bin b in bins) {
      // collection is due, send a notification
      await ns.showNotification(
          title: 'Bin Reminder',
          body:
              '${b.name} is due ${DateHelper.getFormattedNextCollectionDate(b.collectionDate)}');
    }
  }
}

/// background worker task
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    const dateLastRunSharedPrefSettingName = "bgw_lastchecked";

    Logger l = Logger();
    l.d('Workmanager.executeTask called for task $task');

    switch (task) {
      case BackgroundWorker.backgroundWorkerTaskKey:
        final prefs = await SharedPreferences.getInstance();
        String? dateLastRunSetting =
            prefs.getString(dateLastRunSharedPrefSettingName);

        DateTime dateLastRun = (dateLastRunSetting == null
            ? DateHelper.getToday()
            : DateTime.parse(dateLastRunSetting));
        l.d('Last run date = $dateLastRun');

        if (dateLastRun.isBefore(DateHelper.getToday())) {
          l.d('Last run date is in the past, run background tasks');
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
