import 'package:flutter/foundation.dart';

import '../errors/failures.dart';

@immutable
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T getOrThrow() {
    return switch (this) {
      Success<T>(value: final v) => v,
      FailureResult<T>(failure: final f) => throw Exception(f.message),
    };
  }
}

@immutable
class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

@immutable
class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);
}
