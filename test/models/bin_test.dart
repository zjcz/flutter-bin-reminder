import 'package:bin_reminder/models/bin.dart';
import 'package:test/test.dart';

void main() {
  group('Test initialisation of bin object', () {
    test('initialising a new bin object', () {
      int id = 1;
      String name = 'new bin';
      BinType binType = BinType.wheelie;
      BinColor binColor = BinColor.green;
      DateTime collectionDate = DateTime(2024, 2, 5);
      CollectionFrequency collectionFrequency = CollectionFrequency.fortnightly;
      bool isPaused = false;

      Bin b = Bin(
          id: id,
          name: name,
          binType: binType,
          binColor: binColor,
          collectionDate: collectionDate,
          collectionFrequency: collectionFrequency,
          isPaused: isPaused);

      expect(b.id, id);
      expect(b.name, name);
      expect(b.binType, binType);
      expect(b.binColor, binColor);
      expect(b.collectionDate, collectionDate);
      expect(b.collectionFrequency, collectionFrequency);
      expect(b.isPaused, isPaused);
    });

    test('initialising a new paused bin object', () {
      int id = 1;
      String name = 'new bin';
      BinType binType = BinType.wheelie;
      BinColor binColor = BinColor.green;
      DateTime collectionDate = DateTime(2024, 2, 5);
      CollectionFrequency collectionFrequency = CollectionFrequency.fortnightly;
      bool isPaused = true;

      Bin b = Bin(
          id: id,
          name: name,
          binType: binType,
          binColor: binColor,
          collectionDate: collectionDate,
          collectionFrequency: collectionFrequency,
          isPaused: isPaused);

      expect(b.id, id);
      expect(b.name, name);
      expect(b.binType, binType);
      expect(b.binColor, binColor);
      expect(b.collectionDate, collectionDate);
      expect(b.collectionFrequency, collectionFrequency);
      expect(b.isPaused, isPaused);
    });

    test('object converted to map and back again', () {
      int id = 1;
      String name = 'new bin';
      BinType binType = BinType.wheelie;
      BinColor binColor = BinColor.green;
      DateTime collectionDate = DateTime(2024, 2, 5);
      CollectionFrequency collectionFrequency = CollectionFrequency.fortnightly;
      bool isPaused = false;

      Bin original = Bin(
          id: id,
          name: name,
          binType: binType,
          binColor: binColor,
          collectionDate: collectionDate,
          collectionFrequency: collectionFrequency,
          isPaused: isPaused);

      Map<String, dynamic> map = original.toMap();
      Bin duplicate = Bin.fromMap(map);

      expect(original.id, duplicate.id);
      expect(original.name, duplicate.name);
      expect(original.binType, duplicate.binType);
      expect(original.binColor, duplicate.binColor);
      expect(original.collectionDate, duplicate.collectionDate);
      expect(original.collectionFrequency, duplicate.collectionFrequency);
      expect(original.isPaused, duplicate.isPaused);
    });
  });
}
