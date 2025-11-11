import 'package:flutter_test/flutter_test.dart';
import 'package:sahifa/core/utils/debouncer.dart';

void main() {
  group('Debouncer Tests', () {
    late Debouncer debouncer;

    setUp(() {
      debouncer = Debouncer(delay: const Duration(milliseconds: 100));
    });

    tearDown(() {
      debouncer.dispose();
    });

    test('should execute action after delay', () async {
      // Arrange
      bool executed = false;

      // Act
      debouncer.run(() {
        executed = true;
      });

      // Assert - should not execute immediately
      expect(executed, false);

      // Wait for delay
      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, true);
    });

    test('should cancel previous action when called multiple times', () async {
      // Arrange
      int executionCount = 0;

      // Act - Call multiple times rapidly
      debouncer.run(() {
        executionCount++;
      });

      debouncer.run(() {
        executionCount++;
      });

      debouncer.run(() {
        executionCount++;
      });

      // Wait for delay
      await Future.delayed(const Duration(milliseconds: 150));

      // Assert - should only execute once (the last one)
      expect(executionCount, 1);
    });

    test('should cancel pending action when cancel is called', () async {
      // Arrange
      bool executed = false;

      // Act
      debouncer.run(() {
        executed = true;
      });

      // Cancel before delay expires
      debouncer.cancel();

      // Wait for delay
      await Future.delayed(const Duration(milliseconds: 150));

      // Assert - should not execute
      expect(executed, false);
    });

    test('should allow multiple executions if enough time passes', () async {
      // Arrange
      int executionCount = 0;

      // Act - First execution
      debouncer.run(() {
        executionCount++;
      });

      await Future.delayed(const Duration(milliseconds: 150));

      // Second execution after first completes
      debouncer.run(() {
        executionCount++;
      });

      await Future.delayed(const Duration(milliseconds: 150));

      // Assert - should execute twice
      expect(executionCount, 2);
    });

    test('should handle dispose correctly', () async {
      // Arrange
      bool executed = false;

      // Act
      debouncer.run(() {
        executed = true;
      });

      debouncer.dispose();

      // Wait for delay
      await Future.delayed(const Duration(milliseconds: 150));

      // Assert - should not execute after dispose
      expect(executed, false);
    });

    test('should use custom delay duration', () async {
      // Arrange
      final customDebouncer = Debouncer(
        delay: const Duration(milliseconds: 300),
      );
      bool executed = false;

      // Act
      customDebouncer.run(() {
        executed = true;
      });

      // Assert - should not execute before delay
      await Future.delayed(const Duration(milliseconds: 200));
      expect(executed, false);

      // Should execute after delay
      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, true);

      customDebouncer.dispose();
    });

    test('should reset timer when called again during delay', () async {
      // Arrange
      bool executed = false;
      final startTime = DateTime.now();

      // Act - First call
      debouncer.run(() {
        executed = true;
      });

      // Wait 50ms (half the delay)
      await Future.delayed(const Duration(milliseconds: 50));

      // Second call - should reset the timer
      debouncer.run(() {
        executed = true;
      });

      // Wait another 50ms (total 100ms from start, but only 50ms from second call)
      await Future.delayed(const Duration(milliseconds: 50));

      // Should not have executed yet
      expect(executed, false);

      // Wait remaining time
      await Future.delayed(const Duration(milliseconds: 60));

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Assert - should execute and total time should be ~150ms (50ms + 100ms)
      expect(executed, true);
      expect(duration.inMilliseconds, greaterThanOrEqualTo(140));
    });
  });

  group('Debouncer Real-World Scenarios', () {
    test('simulates search typing scenario', () async {
      // Arrange
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      final searchQueries = <String>[];

      void performSearch(String query) {
        searchQueries.add(query);
      }

      // Act - Simulate user typing "test"
      debouncer.run(() => performSearch('t'));
      await Future.delayed(const Duration(milliseconds: 20));

      debouncer.run(() => performSearch('te'));
      await Future.delayed(const Duration(milliseconds: 20));

      debouncer.run(() => performSearch('tes'));
      await Future.delayed(const Duration(milliseconds: 20));

      debouncer.run(() => performSearch('test'));

      // Wait for final debounce
      await Future.delayed(const Duration(milliseconds: 150));

      // Assert - should only perform search once with final query
      expect(searchQueries.length, 1);
      expect(searchQueries.first, 'test');

      debouncer.dispose();
    });

    test('simulates auto-save scenario', () async {
      // Arrange
      final debouncer = Debouncer(delay: const Duration(milliseconds: 200));
      int saveCount = 0;

      void saveData() {
        saveCount++;
      }

      // Act - User types, pauses, types again
      debouncer.run(saveData);
      await Future.delayed(const Duration(milliseconds: 50));

      debouncer.run(saveData);
      await Future.delayed(const Duration(milliseconds: 50));

      debouncer.run(saveData);
      await Future.delayed(const Duration(milliseconds: 250)); // Wait for save

      // User types again after save
      debouncer.run(saveData);
      await Future.delayed(const Duration(milliseconds: 250));

      // Assert - should save twice (once after initial typing, once after second session)
      expect(saveCount, 2);

      debouncer.dispose();
    });
  });
}
