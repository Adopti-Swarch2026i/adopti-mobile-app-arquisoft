import 'package:flutter_test/flutter_test.dart';
import 'package:adopti_mobile/core/errors/failures.dart';
import 'package:adopti_mobile/core/utils/result.dart';

void main() {
  group('Result', () {
    test('Success should have isSuccess true and isFailure false', () {
      const result = Success<int>(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('FailureResult should have isSuccess false and isFailure true', () {
      const result = FailureResult<int>(ServerFailure('error'));
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
    });

    test('getOrThrow on Success returns the value', () {
      const result = Success<String>('hello');
      expect(result.getOrThrow(), equals('hello'));
    });

    test('getOrThrow on FailureResult throws an Exception', () {
      const result = FailureResult<int>(ServerFailure('something went wrong'));
      expect(() => result.getOrThrow(), throwsException);
    });
  });
}
