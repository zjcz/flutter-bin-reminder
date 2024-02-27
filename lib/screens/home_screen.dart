import 'package:flutter/material.dart';
import 'package:bin_reminder/services/database_service.dart';
import 'package:bin_reminder/widgets/bins_list.dart';
import 'package:bin_reminder/widgets/delete_confirmation_dialog.dart';
import 'package:bin_reminder/screens/edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final DatabaseService db = DatabaseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Bin Reminder'), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditScreen()))
                  .then((_) => {setState(() {})});
            },
          ),
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: BinsList(
                    binList: db.listBins(),
                    onEditBin: (bin) {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditScreen(bin: bin)))
                          .then((_) => {setState(() {})});
                    },
                    onDeleteBin: (bin) {
                      showAdaptiveDialog(
                          context: context,
                          builder: (_) => DeleteConfirmationDialog(
                                  onConfirmDelete: () async {
                                await db.deleteBin(bin.id!);
                                setState(() {});
                              }));
                    },
                  )),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
