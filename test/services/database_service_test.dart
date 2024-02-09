import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bin_reminder/services/database_service.dart';
import 'package:test/test.dart';
import 'package:bin_reminder/models/bin.dart';
import 'package:bin_reminder/helpers/date_helper.dart';

Future main() async {
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory for unit testing calls for SQFlite
    databaseFactory = databaseFactoryFfi;

    // delete the existing database so we always start with fresh
    databaseFactory
        .deleteDatabase(await DatabaseService().getDatabaseFilename());
  });

  tearDownAll(() async {
    // delete the database when done
    databaseFactory
        .deleteDatabase(await DatabaseService().getDatabaseFilename());
  });

  tearDown(() async {
    // delete all the bins in the table.  Runs after each test to ensure table is empty
    DatabaseService ds = DatabaseService();
    await ds.deleteAll();
  });

  group('Test insert of bin object', () {
    test('test insert returns new id', () async {
      String name = 'new bin';
      BinType binType = BinType.wheelie;
      BinColor binColor = BinColor.green;
      DateTime collectionDate = DateTime(2024, 2, 5);
      CollectionFrequency collectionFrequency = CollectionFrequency.fortnightly;
      bool isPaused = false;

      Bin b = Bin(
          id: null,
          name: name,
          binType: binType,
          binColor: binColor,
          collectionDate: collectionDate,
          collectionFrequency: collectionFrequency,
          isPaused: isPaused);

      DatabaseService ds = DatabaseService();
      int newId = await ds.insertBin(b);

      expect(newId, 1);
      expect(b.id, null);
      expect(b.name, name);
      expect(b.binType, binType);
      expect(b.binColor, binColor);
      expect(b.collectionDate, collectionDate);
      expect(b.collectionFrequency, collectionFrequency);
      expect(b.isPaused, isPaused);
    });

    test('test insert with existing id returns id', () async {
      int id = 5;

      Bin b = Bin(
          id: id,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2024, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      DatabaseService ds = DatabaseService();
      int newId = await ds.insertBin(b);

      expect(newId, id);
    });

    test('test insert saves all properties', () async {
      String name = 'new bin';
      BinType binType = BinType.wheelie;
      BinColor binColor = BinColor.green;
      DateTime collectionDate = DateTime(2024, 2, 5);
      CollectionFrequency collectionFrequency = CollectionFrequency.fortnightly;
      bool isPaused = false;

      Bin b = Bin(
          id: null,
          name: name,
          binType: binType,
          binColor: binColor,
          collectionDate: collectionDate,
          collectionFrequency: collectionFrequency,
          isPaused: isPaused);

      DatabaseService ds = DatabaseService();
      int newId = await ds.insertBin(b);
      Bin newBin = await ds.getBin(newId);

      expect(newBin.id, newId);
      expect(newBin.name, name);
      expect(newBin.binType, binType);
      expect(newBin.binColor, binColor);
      expect(newBin.collectionDate, collectionDate);
      expect(newBin.collectionFrequency, collectionFrequency);
      expect(newBin.isPaused, isPaused);
    });

    test('test auto id does not reuse max id', () async {
      // insert two records,
      // delete the first
      // insert a new one.  Should be given the id of 3
      Bin b1 = Bin(
          id: null,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2024, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      Bin b2 = Bin(
          id: null,
          name: 'new bin 2',
          binType: BinType.industrial,
          binColor: BinColor.blue,
          collectionDate: DateTime(2022, 3, 10),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: false);

      Bin b3 = Bin(
          id: null,
          name: 'new bin 3',
          binType: BinType.bag,
          binColor: BinColor.red,
          collectionDate: DateTime(2021, 12, 15),
          collectionFrequency: CollectionFrequency.weekly,
          isPaused: false);

      DatabaseService ds = DatabaseService();
      int newId1 = await ds.insertBin(b1);
      await ds.insertBin(b2);
      await ds.deleteBin(newId1);
      int newId3 = await ds.insertBin(b3);
      expect(newId3, 3);
    });

    test('test auto id does not reuse max id', () async {
      // insert two records,
      // delete the last
      // insert a new one.  Should be given the id of 2
      Bin b1 = Bin(
          id: null,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2024, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      Bin b2 = Bin(
          id: null,
          name: 'new bin 2',
          binType: BinType.industrial,
          binColor: BinColor.blue,
          collectionDate: DateTime(2022, 3, 10),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: false);

      Bin b3 = Bin(
          id: null,
          name: 'new bin 3',
          binType: BinType.bag,
          binColor: BinColor.red,
          collectionDate: DateTime(2021, 12, 15),
          collectionFrequency: CollectionFrequency.weekly,
          isPaused: false);

      DatabaseService ds = DatabaseService();
      await ds.insertBin(b1);
      int newId2 = await ds.insertBin(b2);
      await ds.deleteBin(newId2);
      int newId3 = await ds.insertBin(b3);
      expect(newId3, 2);
    });
  });

  group('Test list and get for bin object', () {
    test('test list returns correct data', () async {
      Bin b1 = Bin(
          id: null,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2022, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      Bin b2 = Bin(
          id: null,
          name: 'new bin 2',
          binType: BinType.industrial,
          binColor: BinColor.blue,
          collectionDate: DateTime(2022, 3, 10),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: false);

      DatabaseService ds = DatabaseService();
      int newId1 = await ds.insertBin(b1);
      int newId2 = await ds.insertBin(b2);
      List<Bin> bins = await ds.listBins();

      expect(bins.length, 2);
      expect(bins[0].id, newId1);
      expect(bins[0].name, b1.name);
      expect(bins[0].binType, b1.binType);
      expect(bins[0].binColor, b1.binColor);
      expect(bins[0].collectionDate, b1.collectionDate);
      expect(bins[0].collectionFrequency, b1.collectionFrequency);
      expect(bins[0].isPaused, b1.isPaused);
      expect(bins[1].id, newId2);
      expect(bins[1].name, b2.name);
      expect(bins[1].binType, b2.binType);
      expect(bins[1].binColor, b2.binColor);
      expect(bins[1].collectionDate, b2.collectionDate);
      expect(bins[1].collectionFrequency, b2.collectionFrequency);
      expect(bins[1].isPaused, b2.isPaused);
    });

    test('test get method returns correct bin', () async {
      Bin b1 = Bin(
          id: null,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2024, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      Bin b2 = Bin(
          id: null,
          name: 'new bin 2',
          binType: BinType.industrial,
          binColor: BinColor.blue,
          collectionDate: DateTime(2022, 3, 10),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: false);

      DatabaseService ds = DatabaseService();
      await ds.insertBin(b1);
      int newId2 = await ds.insertBin(b2);
      Bin bin = await ds.getBin(newId2);

      expect(bin.id, newId2);
      expect(bin.name, b2.name);
      expect(bin.binType, b2.binType);
      expect(bin.binColor, b2.binColor);
      expect(bin.collectionDate, b2.collectionDate);
      expect(bin.collectionFrequency, b2.collectionFrequency);
      expect(bin.isPaused, b2.isPaused);
    });

    test('test list returns in correct order', () async {
      // expect to be ordered in collection date order,
      // with upcoming collections at the top
      // paused bins at the end
      Bin b1 = Bin(
          id: null,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2024, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: true);

      Bin b2 = Bin(
          id: null,
          name: 'new bin 2',
          binType: BinType.industrial,
          binColor: BinColor.blue,
          collectionDate: DateTime(2024, 3, 2),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: false);

      Bin b3 = Bin(
          id: null,
          name: 'new bin 3',
          binType: BinType.bag,
          binColor: BinColor.black,
          collectionDate: DateTime(2024, 3, 1),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: false);

      DatabaseService ds = DatabaseService();
      int newId1 = await ds.insertBin(b1);
      int newId2 = await ds.insertBin(b2);
      int newId3 = await ds.insertBin(b3);
      List<Bin> bins = await ds.listBins();

      expect(bins.length, 3);
      expect(bins[0].id, newId3);
      expect(bins[1].id, newId2);
      expect(bins[2].id, newId1);
    });
  });

  group('Test delete for bin object', () {
    test('test delete removes bin', () async {
      Bin b1 = Bin(
          id: null,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2024, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      Bin b2 = Bin(
          id: null,
          name: 'new bin 2',
          binType: BinType.industrial,
          binColor: BinColor.blue,
          collectionDate: DateTime(2022, 3, 10),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: false);

      DatabaseService ds = DatabaseService();
      int newId1 = await ds.insertBin(b1);
      int newId2 = await ds.insertBin(b2);
      await ds.deleteBin(newId1);
      List<Bin> bins = await ds.listBins();

      expect(bins.length, 1);
      expect(bins[0].id, newId2);
    });

    test('test delete all on empty table causes no errors', () async {
      DatabaseService ds = DatabaseService();
      await ds.deleteAll();
      await ds.deleteAll();
      List<Bin> bins = await ds.listBins();

      expect(bins.length, 0);
    });
  });

  group('Test update for bin object', () {
    test('test update method correctly updates bin object', () async {
      Bin b1 = Bin(
          id: null,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2024, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      DatabaseService ds = DatabaseService();
      int newId = await ds.insertBin(b1);

      Bin b2 = Bin(
          id: newId,
          name: 'new bin 2',
          binType: BinType.industrial,
          binColor: BinColor.blue,
          collectionDate: DateTime(2022, 3, 10),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: true);

      await ds.updateBin(b2);
      Bin modifiedBin = await ds.getBin(newId);

      expect(modifiedBin.id, newId);
      expect(modifiedBin.name, b2.name);
      expect(modifiedBin.binType, b2.binType);
      expect(modifiedBin.binColor, b2.binColor);
      expect(modifiedBin.collectionDate, b2.collectionDate);
      expect(modifiedBin.collectionFrequency, b2.collectionFrequency);
      expect(modifiedBin.isPaused, b2.isPaused);
    });
  });

  group('Test updating past collection dates for bin object', () {
    test('test updatePastCollectionDates method correctly updates bin object',
        () async {
      Bin b1 = Bin(
          id: null,
          name: 'new bin',
          binType: BinType.wheelie,
          binColor: BinColor.green,
          collectionDate: DateTime(2020, 2, 5),
          collectionFrequency: CollectionFrequency.fortnightly,
          isPaused: false);

      Bin b2 = Bin(
          id: null,
          name: 'new bin 2',
          binType: BinType.industrial,
          binColor: BinColor.blue,
          collectionDate: DateHelper.getToday(),
          collectionFrequency: CollectionFrequency.weekly,
          isPaused: true);

      Bin b3 = Bin(
          id: null,
          name: 'new bin 3',
          binType: BinType.bag,
          binColor: BinColor.grey,
          collectionDate: DateHelper.getToday().add(const Duration(days: 10)),
          collectionFrequency: CollectionFrequency.monthly,
          isPaused: true);

      DatabaseService ds = DatabaseService();
      await ds.insertBin(b1);
      await ds.insertBin(b2);
      await ds.insertBin(b3);
      await ds.updatePastCollectionDates();
      List<Bin> bins = await ds.listBins();

      expect(bins.length, 3);
      expect(bins[0].collectionDate.millisecondsSinceEpoch,
          greaterThanOrEqualTo(DateHelper.getToday().millisecondsSinceEpoch));
      expect(bins[1].collectionDate.millisecondsSinceEpoch,
          greaterThanOrEqualTo(DateHelper.getToday().millisecondsSinceEpoch));
      expect(bins[2].collectionDate, b3.collectionDate); // should be unchanged
    });
  });
}
