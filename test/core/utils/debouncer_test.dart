import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/core/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('should delay action execution', () async {
      final debouncer = Debouncer(milliseconds: 500);
      var counter = 0;

      debouncer.run(() => counter++);
      expect(counter, 0);

      await Future.delayed(const Duration(milliseconds: 600));
      expect(counter, 1);

      debouncer.dispose();
    });

    test('should cancel previous timer when called again', () async {
      final debouncer = Debouncer(milliseconds: 500);
      var counter = 0;

      debouncer.run(() => counter++);
      await Future.delayed(const Duration(milliseconds: 200));
      debouncer.run(() => counter++);
      await Future.delayed(const Duration(milliseconds: 200));
      debouncer.run(() => counter++);

      // Only the last action should execute
      await Future.delayed(const Duration(milliseconds: 600));
      expect(counter, 1);

      debouncer.dispose();
    });

    test('should return isActive status correctly', () async {
      final debouncer = Debouncer(milliseconds: 500);
      var counter = 0;

      expect(debouncer.isActive, false);

      debouncer.run(() => counter++);
      expect(debouncer.isActive, true);

      await Future.delayed(const Duration(milliseconds: 600));
      expect(debouncer.isActive, false);

      debouncer.dispose();
    });

    test('should cancel pending action', () async {
      final debouncer = Debouncer(milliseconds: 500);
      var counter = 0;

      debouncer.run(() => counter++);
      debouncer.cancel();

      await Future.delayed(const Duration(milliseconds: 600));
      expect(counter, 0);

      debouncer.dispose();
    });

    test('should dispose correctly', () async {
      final debouncer = Debouncer(milliseconds: 500);
      var counter = 0;

      debouncer.run(() => counter++);
      debouncer.dispose();

      expect(debouncer.isActive, false);
      await Future.delayed(const Duration(milliseconds: 600));
      expect(counter, 0);
    });

    test('should handle multiple runs correctly', () async {
      final debouncer = Debouncer(milliseconds: 300);
      var counter = 0;

      debouncer.run(() => counter++);
      await Future.delayed(const Duration(milliseconds: 400));
      expect(counter, 1);

      debouncer.run(() => counter++);
      await Future.delayed(const Duration(milliseconds: 400));
      expect(counter, 2);

      debouncer.dispose();
    });
  });

  group('Throttler', () {
    test('should execute action immediately', () {
      final throttler = Throttler(milliseconds: 500);
      var counter = 0;

      throttler.run(() => counter++);
      expect(counter, 1);

      throttler.dispose();
    });

    test('should prevent execution during throttle period', () async {
      final throttler = Throttler(milliseconds: 500);
      var counter = 0;

      throttler.run(() => counter++);
      throttler.run(() => counter++);
      throttler.run(() => counter++);

      expect(counter, 1);

      await Future.delayed(const Duration(milliseconds: 600));
      expect(counter, 1);

      throttler.dispose();
    });

    test('should allow execution after throttle period', () async {
      final throttler = Throttler(milliseconds: 500);
      var counter = 0;

      throttler.run(() => counter++);
      expect(counter, 1);

      await Future.delayed(const Duration(milliseconds: 600));

      throttler.run(() => counter++);
      expect(counter, 2);

      throttler.dispose();
    });

    test('should return isThrottling status correctly', () async {
      final throttler = Throttler(milliseconds: 500);
      var counter = 0;

      expect(throttler.isThrottling, false);

      throttler.run(() => counter++);
      expect(throttler.isThrottling, true);

      await Future.delayed(const Duration(milliseconds: 600));
      expect(throttler.isThrottling, false);

      throttler.dispose();
    });

    test('should reset throttle state', () async {
      final throttler = Throttler(milliseconds: 500);
      var counter = 0;

      throttler.run(() => counter++);
      expect(throttler.isThrottling, true);

      throttler.reset();
      expect(throttler.isThrottling, false);

      throttler.run(() => counter++);
      expect(counter, 2);

      throttler.dispose();
    });

    test('should dispose correctly', () {
      final throttler = Throttler(milliseconds: 500);
      var counter = 0;

      throttler.run(() => counter++);
      throttler.dispose();

      expect(throttler.isThrottling, false);
    });

    test('should handle rapid calls correctly', () async {
      final throttler = Throttler(milliseconds: 300);
      var counter = 0;

      // First call should execute
      throttler.run(() => counter++);
      expect(counter, 1);

      // These should be blocked
      for (int i = 0; i < 10; i++) {
        throttler.run(() => counter++);
      }
      expect(counter, 1);

      // Wait for throttle to expire
      await Future.delayed(const Duration(milliseconds: 400));

      // This should execute
      throttler.run(() => counter++);
      expect(counter, 2);

      throttler.dispose();
    });
  });
}
