import 'package:bin_reminder/helpers/date_helper.dart';
import 'package:bin_reminder/models/bin.dart';
import 'package:test/test.dart';
import 'package:clock/clock.dart';

void main() {
  group('Test calc next collection date', () {
    test('handles collection date of today', () {
      DateTime lastCollection = DateTime(2024, 1, 1);
      DateTime today = DateTime(2024, 1, 1);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        DateTime nextCollectionDate = DateHelper.getNextCollectionDate(
            lastCollection, CollectionFrequency.weekly);

        expect(nextCollectionDate, today);
      });
    });

    test('calc next weekly collection for collection date of yesterday ', () {
      DateTime lastCollection = DateTime(2024, 1, 1);
      DateTime expectedCollection = DateTime(2024, 1, 8);
      DateTime today = DateTime(2024, 1, 2);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        DateTime nextCollectionDate = DateHelper.getNextCollectionDate(
            lastCollection, CollectionFrequency.weekly);

        expect(nextCollectionDate, expectedCollection);
      });
    });

    test('calc next fortnightly collection for collection date of yesterday ',
        () {
      DateTime lastCollection = DateTime(2024, 1, 1);
      DateTime expectedCollection = DateTime(2024, 1, 15);
      DateTime today = DateTime(2024, 1, 2);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        DateTime nextCollectionDate = DateHelper.getNextCollectionDate(
            lastCollection, CollectionFrequency.fortnightly);

        expect(nextCollectionDate, expectedCollection);
      });
    });

    test('calc next monthly collection for collection date of yesterday ', () {
      DateTime lastCollection = DateTime(2024, 1, 1);
      DateTime expectedCollection = DateTime(2024, 1, 29);
      DateTime today = DateTime(2024, 1, 2);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        DateTime nextCollectionDate = DateHelper.getNextCollectionDate(
            lastCollection, CollectionFrequency.monthly);

        expect(nextCollectionDate, expectedCollection);
      });
    });

    test('calc next weekly collection for collection date of a week ago ', () {
      DateTime lastCollection = DateTime(2024, 1, 1); // sunday
      DateTime expectedCollection = DateTime(2024, 1, 8);
      DateTime today = DateTime(2024, 1, 8);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        DateTime nextCollectionDate = DateHelper.getNextCollectionDate(
            lastCollection, CollectionFrequency.weekly);

        expect(nextCollectionDate, expectedCollection);
      });
    });

    test('calc next weekly collection for collection date of a year ago ', () {
      DateTime lastCollection = DateTime(2023, 1, 1); // sunday
      DateTime expectedCollection =
          DateTime(2024, 1, 7); // the first sunday after 1 Jan 2024
      DateTime today = DateTime(2024, 1, 1);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        DateTime nextCollectionDate = DateHelper.getNextCollectionDate(
            lastCollection, CollectionFrequency.weekly);

        expect(nextCollectionDate, expectedCollection);
      });
    });
  });

  group('Test formatting of next collection date', () {
    test('handles collection date of today', () {
      DateTime nextCollection = DateTime(2024, 1, 1); // today
      DateTime today = DateTime(2024, 1, 1);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        String nextCollectionDate =
            DateHelper.getFormattedNextCollectionDate(nextCollection);

        expect(nextCollectionDate, 'Today');
      });
    });

    test('handles collection date of tomorrow', () {
      DateTime nextCollection = DateTime(2024, 1, 2); // tomorrow
      DateTime today = DateTime(2024, 1, 1);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        String nextCollectionDate =
            DateHelper.getFormattedNextCollectionDate(nextCollection);

        expect(nextCollectionDate, 'Tomorrow');
      });
    });

    test('handles collection date of named day (after tomorrow)', () {
      DateTime nextCollection = DateTime(2024, 1, 3); // wednesday
      DateTime today = DateTime(2024, 1, 1);
      final fakeClock = Clock(() => today);

      withClock(fakeClock, () {
        String nextCollectionDate =
            DateHelper.getFormattedNextCollectionDate(nextCollection);

        expect(nextCollectionDate, 'Wednesday, 3rd January');
      });
    });
  });
}
