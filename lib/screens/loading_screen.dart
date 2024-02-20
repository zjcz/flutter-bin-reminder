import 'package:bin_reminder/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:bin_reminder/services/database_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:bin_reminder/services/background_worker.dart';
import 'package:bin_reminder/services/notification_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> initialiseApp() async {
    // before loading the app, ensure all the
    // bins have a collection date in the future
    DatabaseService ds = DatabaseService();
    await ds.updatePastCollectionDates();

    // Initialise notifications
    NotificationService ns = NotificationService();
    await ns.initNotification();

    // initialise the background worker task
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    // trigger the background task to run every hour
    await Workmanager().registerPeriodicTask(
        BackgroundWorker.backgroundWorkerUniqueName,
        BackgroundWorker.backgroundWorkerTaskKey,
        frequency: const Duration(hours: 1),
        existingWorkPolicy: ExistingWorkPolicy.keep);

    // now load the main home page.  We use pushReplacement so the user
    // doesn't return to this screen when exiting the app
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    initialiseApp().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
